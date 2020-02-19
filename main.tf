#ALB
module "jumbo_alb" {
  source = "./modules/alb"
  create_alb            = var.create_alb
  environments          = var.environments
  public_subnets        = module.jumbo_vpc.vpc_public_subents
  app_name              = var.app_name
  security_group_id     = module.security_group.security_group_id
  vpc_id                = module.jumbo_vpc.vpc_id
  logging_enabled       = var.alb_logging_enabled
  owners                = var.owners
  projects              = var.projects
  ecs_port              = var.app_port
  secure_port           = var.secure_port
  target_groups_count   = length(var.environments)
  alb_listener_protocol = var.alb_listener_protocol
  alb_ssl_policy        = var.alb_ssl_policy
  # TODO: Create new data cert is not implemented
  certificate_arn       = var.existing_certificate_arn[0]
  domain                = var.domain

  target_groups         = [
    for e in var.environments:
    map("name", "${e}-${var.app_name}-tg", "backend_protocol", "HTTP", "backend_port", "${var.app_port}", "target_type", "ip", "health_check_path", "/healthcheck")
  ]  
}

#ASG
module "asg" {
  source                    = "./modules/auto-scaling-group"
  app_name                  = var.app_name
  create                    = length(var.ecs_container) > 0 ? (var.ecs_container[0] == "EC2" ? true: false): false
  environments              = var.environments
  ecs_cluster_name          = length(var.asg_existing_ecs) > 0 ? var.asg_existing_ecs[0]: module.ecs_cluster.ecs_cluster_name
  auto_scaling_role_iam_arn = length(var.asg_existing_iam_role) > 0 ? var.asg_existing_iam_role[0]: module.asg_iam_role.iam_role_arn
  asg_min_capacity          = var.asg_min_size
  asg_max_capacity          = var.asg_max_size
}

module "asg_iam_role" {
  source    = "./modules/iam-role"
  create    = length(var.ecs_container) > 0 ? (length(var.asg_existing_iam_role) > 0 ? false: true): false
  app_name  = var.app_name
  owners    = var.owners
  projects  = var.projects
  role_type = length(var.ecs_container) > 0 ? ["ASG"]: []
}

#ECS
module "ecs_cluster" {
  source                    = "./modules/ecs"
  # New ECS Cluster
  # TODO refactor to allow for more customization in each environment
  app_name                  = var.app_name
  ecs_container             = var.ecs_container
  create                    = length(var.ecs_container) > 0 ? true: false
  app_port                  = var.app_port
  secure_port               = var.secure_port
  aws_region                = var.aws_region
  execution_role_arn        = length(var.ecs_existing_iam_role) > 0 ? var.ecs_existing_iam_role[0]: module.ecs_iam_role.iam_role_arn
  provisioned_memory        = var.provisioned_memory
  environments              = var.environments
  container_count           = var.container_count
  security_group_id         = module.security_group.security_group_id
  public_subnets            = module.jumbo_vpc.vpc_public_subents
  instance_role_name        = length(var.ec2_existing_iam_role) > 0 ? var.ec2_existing_iam_role[0]: module.ec2_iam_role.iam_role_name
  instance_type             = var.instance_type
  key_pair                  = var.key_pair
  instance_root_volume_size = var.instance_root_volume_size
  asg_max_size              = var.asg_max_size
  asg_min_size              = var.asg_min_size
  asg_desired_size          = var.asg_desired_size
  is_ec2                    = length(var.ecs_container) > 0 ? (var.ecs_container[0] == "EC2" ? true:false): false
  target_group_arns         = module.jumbo_alb.target_group_arns
  alb_listener              = module.jumbo_alb.alb_listener
  role_policy_attachment    = module.ecs_iam_role.iam_role_policy_attachment
  # Existing ECS Cluster

}

module "ecs_iam_role" {
  source    = "./modules/iam-role"
  create    = length(var.ecs_container) > 0 ? (length(var.ecs_existing_iam_role) > 0 ? false: true): false
  app_name  = var.app_name
  owners    = var.owners
  projects  = var.projects
  role_type = length(var.ecs_container) > 0 ? ["ECS"]: []
}

module "ec2_iam_role" {
  source        = "./modules/iam-role"
  create        = length(var.ecs_container) > 0 ? (length(var.ec2_existing_iam_role) > 0 ? false: true): false
  app_name      = var.app_name
  owners        = var.owners
  projects      = var.projects
  role_type     = length(var.ecs_container) > 0 ? ["EC2"]: []
  custom_policy = [var.instance_policy]
}

# NOTE we can switch to this style if we can do multiple roles at a time
# module "ecs_iam_role" {
#   source        = "../iam-role"
#   create        = length(var.ecs_container) > 0 ? true: false
#   app_name      = var.app_name
#   owners        = var.owners
#   projects      = var.projects
#   role_type     = [var.ecs_container[0]]
#   custom_policy = var.ecs_container[0] == "EC2" ? [var.instance_policy]: []
# }

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
  private_subnets                             = module.jumbo_vpc.vpc_private_subents
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
  names              = var.parameter_store_names
  descriptions       = var.parameter_store_descriptions
  types              = var.parameter_store_types
  values             = var.parameter_store_values
  existing_parameter = var.existing_parameter_store_name
}

#Routes
module "routes" {
  source = "./modules/routes"
  create_route53            = var.create_route53
  environments              = var.environments
  app_name                  = var.app_name
  domain                    = var.domain
  existing_private_zone     = var.existing_private_zone
  route53_record_type       = var.route53_record_type
  alb_dns_name              = module.jumbo_alb.dns_name
  alb_load_balancer_zone_id = module.jumbo_alb.load_balancer_zone_id
  evaluate_target_health    = var.evaluate_target_health
}

#S3
module "s3_bucket" {
  source          = "./modules/s3-bucket"
  create          = var.create_s3
  existing_bucket = var.existing_s3_bucket
  app_name        = var.app_name
  owners          = var.owners
  projects        = var.projects
}

module "s3_object" {
  source             = "./modules/s3-object"
  s3_bucket          = module.s3_bucket.bucket_name
  s3_keys            = var.s3_object_keys
  s3_filepaths       = var.s3_object_locations
  existing_s3_object = var.existing_s3_object
}

#Security
module "security_group" {
  source                  = "./modules/security"
  vpc_id                  = module.jumbo_vpc.vpc_id
  app_name                = var.app_name
  existing_security_group = var.existing_security_group
  # ingress_rules           = var.ingress_rules
  # ingress_cidr_blocks     = var.ingress_cidr_blocks
  # egress_rules            = var.egress_rules
  # egress_cidr_blocks      = var.egress_cidr_blocks
  owners                  = var.owners
  projects                = var.projects
  # Pass in a list of maps with fields mapped. 1 map = 1 security group to create. This way custom security groups can be set up for each environment
  security_groups_to_create = [{
    "ingress_rules" = var.ingress_rules,
    "ingress_cidr_blocks" = var.ingress_cidr_blocks,
    "egress_rules" = var.egress_rules,
    "egress_cidr_blocks" = var.egress_cidr_blocks}]

  /*
  target_groups         = [
    for e in var.environments:
    map("name", "${e}-${var.app_name}-tg", "backend_protocol", "HTTP", "backend_port", "${var.app_port}", "target_type", "ip", "health_check_path", "/healthcheck")
  ]  
  */
}

#VPC
module "jumbo_vpc" {
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
