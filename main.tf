#ALB
module "alb" {
  source = "./modules/alb"
  create_alb            = (var.ecs_is_web_facing) ? true: var.create_alb
  environments          = var.environments
  public_subnets        = module.vpc.vpc_public_subents
  app_name              = var.app_name
  security_group_id     = module.security_group.security_group_id
  vpc_id                = module.vpc.vpc_id
  logging_enabled       = var.alb_logging_enabled
  owners                = var.owners
  projects              = var.projects
  ecs_port              = var.app_port
  secure_port           = var.secure_port
  alb_listener_protocol = var.alb_listener_protocol
  alb_ssl_policy        = var.alb_ssl_policy
  # TODO: Create new data cert is not implemented
  certificate_arn       = var.existing_certificate_arn[0]
  domain                = var.domain

  target_groups         = length(var.ecs_type) > 0 ? (var.ecs_type[0] == "FARGATE" ? [
    for e in var.environments:
    map("name", "${e}-${var.app_name}-tg", "backend_protocol", "HTTP", "backend_port", "${var.app_port}", "target_type", "ip", "health_check_path", "/healthcheck")
  ] : [
    for e in var.environments:
    map("name", "${e}-${var.app_name}-tg", "backend_protocol", "HTTP", "backend_port", "${var.app_port}", "health_check_path", "/healthcheck")
  ]) : []
}

#ASG
module "asg" {
  source                    = "./modules/auto-scaling-group"
  app_name                  = var.app_name
  create                    = length(var.ecs_type) > 0 ? true: false
  environments              = var.environments
  ecs_cluster_name          = length(var.asg_existing_ecs) > 0 ? var.asg_existing_ecs[0]: module.ecs_cluster.ecs_cluster_name
  auto_scaling_role_iam_arn = length(var.asg_existing_iam_role) > 0 ? var.asg_existing_iam_role[0]: module.asg_iam_role.iam_role_arn
  asg_min_capacity          = var.asg_min_size
  asg_max_capacity          = var.asg_max_size
  add_asg_policies      = var.asg_add_asg_policies
}

module "asg_iam_role" {
  source    = "./modules/iam-role"
  create    = length(var.ecs_type) > 0 ? (length(var.asg_existing_iam_role) > 0 ? false: true): false
  app_name  = var.app_name
  owners    = var.owners
  projects  = var.projects
  role_type = length(var.ecs_type) > 0 ? ["ASG"]: []
}

#ECS
module "ecs_cluster" {
  source                    = "./modules/ecs"
  # New ECS Cluster
  # TODO refactor to allow for more customization in each environment
  app_name                  = var.app_name
  ecs_type                  = var.ecs_type
  create                    = length(var.ecs_type) > 0 ? (length(var.existing_vpcs) == 0 ? true : (var.existing_vpcs[0] != "" ? true: false)): false
  app_port                  = var.app_port
  aws_region                = var.aws_region
  execution_role_arn        = length(var.ecs_existing_iam_role) > 0 ? var.ecs_existing_iam_role[0]: module.ecs_iam_role.iam_role_arn
  provisioned_memory        = var.provisioned_memory
  environments              = var.environments
  container_count           = var.container_count
  security_group_id         = module.security_group.security_group_id
  public_subnets            = module.vpc.vpc_public_subents
  instance_role_name        = length(var.ec2_existing_iam_role) > 0 ? var.ec2_existing_iam_role[0]: module.ec2_iam_role.iam_role_name
  instance_type             = var.instance_type
  key_pair                  = var.key_pair
  instance_root_volume_size = var.instance_root_volume_size
  asg_max_size              = var.asg_max_size
  asg_min_size              = var.asg_min_size
  asg_desired_size          = var.asg_desired_size
  is_ec2                    = length(var.ecs_type) > 0 ? (var.ecs_type[0] == "EC2" ? true:false): false
  target_group_arns         = module.alb.target_group_arns
  alb_listener              = module.alb.alb_listener
  role_policy_attachment    = module.ecs_iam_role.iam_role_policy_attachment
  network_mode              = /*var.ecs_is_web_facing*/ length(var.ecs_type) > 0 ? (var.ecs_type[0] == "EC2" ? "bridge": "awsvpc"): "bridge"
  is_web_facing             = var.ecs_is_web_facing
  # Existing ECS Cluster

}

module "ecs_iam_role" {
  source    = "./modules/iam-role"
  create    = length(var.ecs_type) > 0 ? (length(var.ecs_existing_iam_role) > 0 ? false: true): false
  app_name  = var.app_name
  owners    = var.owners
  projects  = var.projects
  role_type = length(var.ecs_type) > 0 ? ["ECS"]: []
}

module "ec2_iam_role" {
  source        = "./modules/iam-role"
  create        = length(var.ecs_type) > 0 ? (length(var.ec2_existing_iam_role) > 0 ? false: (var.ecs_type[0] == "EC2" ? true:false)): false
  app_name      = var.app_name
  owners        = var.owners
  projects      = var.projects
  role_type     = length(var.ecs_type) > 0 ? ["EC2"]: []
  custom_policy = [var.instance_policy]
}

# NOTE we can switch to this style if we can do multiple roles at a time
# module "ecs_iam_role" {
#   source        = "../iam-role"
#   create        = length(var.ecs_type) > 0 ? true: false
#   app_name      = var.app_name
#   owners        = var.owners
#   projects      = var.projects
#   role_type     = [var.ecs_type[0]]
#   custom_policy = var.ecs_type[0] == "EC2" ? [var.instance_policy]: []
# }

#IAM User
# NOTE we can only create one user as of now
module "iam_user" {
  source = "./modules/iam-user"
  ecr_repository_arn = var.default_user_ecr_policy != "" ? var.default_user_ecr_policy : module.ecs_cluster.ecr_repository_arn
  users              = var.create_iam_user ? (length(var.iam_users) > 0 ? var.iam_users: (length(var.ecs_type) > 0 ? [{"name" = "", "policies" = ["ECR", "ECS"]}]: [{"name" = "", "policies" = []}])): []
  app_name           = var.app_name
  owners             = var.owners
  projects           = var.projects
}

#lambda
module "lambda" {
  source = "./modules/lambda"
  create_lambda                               = var.create_lambda ? (length(var.existing_lambda) > 0 ? false : true): false
  lambda_role_name                            = module.lambda_iam_role.iam_role_name 
  environments                                = var.environments
  app_name                                    = var.app_name
  lambda_cloudwatch_logging                   = var.lambda_cloudwatch_logging
  lambda_cloudwatch_logging_retention_in_days = var.lambda_cloudwatch_logging_retention_in_days
  alias_name                                  = var.alias_name
  alias_function_version                      = var.alias_function_version
  s3_bucket                                   = length(var.lambda_s3_bucket) > 0 ? var.lambda_s3_bucket[0] : module.s3_bucket.bucket_name
  s3_key                                      = var.lambda_s3_key
  private_subnets                             = module.vpc.vpc_private_subents
  security_group_id                           = module.security_group.security_group_id
  lambda_runtime                              = var.lambda_runtime
  lambda_iam_role_arn                         = module.lambda_iam_role.iam_role_arn
  handler                                     = var.handler
  owners                                      = var.owners
  projects                                    = var.projects
  schedule_expression                         = var.schedule_expression
  lambda_timeout                              = var.lambda_timeout
  existing_lambda                             = var.existing_lambda
}

module "lambda_iam_role" {
  source        = "./modules/iam-role"
  create        = var.create_lambda
  app_name      = var.app_name
  owners        = var.owners
  projects      = var.projects
  role_type     = length(var.existing_lambda_role) > 0 ? ["lambda"]: []
  custom_policy = [var.lambda_role_policy, var.lambda_policy]
}

#Parameters
module "parameters" {
  source             = "./modules/parameter-store"
  existing_parameter = var.existing_parameter_store_name
  parameters         = var.parameters
}

#Routes
module "routes" {
  source = "./modules/routes"
  create_route53            = var.ecs_is_web_facing ? (var.domain == "" ? false : true): (var.create_route53 ? (var.domain == "" ? false : true): false)
  # Route53 route is environment-app_name-domain
  environments              = var.environments
  app_name                  = var.app_name
  domain                    = var.domain
  existing_private_zone     = var.existing_private_zone
  route53_record_type       = var.route53_record_type
  alb_dns_name              = module.alb.dns_name
  alb_load_balancer_zone_id = module.alb.load_balancer_zone_id
  evaluate_target_health    = var.evaluate_target_health
}

#S3
module "s3_bucket" {
  source          = "./modules/s3-bucket"
  create          = var.create_s3_bucket
  existing_bucket = var.existing_s3_bucket
  app_name        = var.app_name
  owners          = var.owners
  projects        = var.projects
}

module "s3_object" {
  source             = "./modules/s3-object"
  s3_bucket          = module.s3_bucket.bucket_name
  existing_s3_object = var.existing_s3_object
  s3_objects         = [
    for o in var.s3_objects:
    {
      "bucket"   = o["bucket"] == "" ? module.s3_bucket.bucket_name: o["bucket"],
      "key"      = o["key"],
      "filepath" = o["filepath"]
    }
  ]
}

#Security
module "security_group" {
  source                  = "./modules/security"
  vpc_id                  = module.vpc.vpc_id
  app_name                = var.app_name
  existing_security_group = var.existing_security_group
  owners                  = var.owners
  projects                = var.projects
  # Pass in a list of maps with fields mapped. 1 map = 1 security group to create. This way custom security groups can be set up for each environment
  security_groups_to_create = var.security_group_rules_to_create
}

#VPC
module "vpc" {
  source   = "./modules/vpc"
  app_name = var.app_name
  #Tags
  owners   = var.owners
  projects = var.projects
  #VPC
  # If using existing VPC only set this:
  existing_vpcs = var.existing_vpcs
  # If creating a new VPC Set the following:
  # Required if creating new VPC
  cidr_block         = var.cidr_block
  availability_zones = var.availability_zones
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  # Optional
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_nat_gateway   = var.enable_nat_gateway
  enable_vpn_gateway   = var.enable_vpn_gateway
  single_nat_gateway   = var.single_nat_gateway
  reuse_nat_ips        = var.reuse_nat_ips
}
