module "ecs_cluster" {
  source                    = "../ecs-ec2"
  #New ECS EC2 Cluster
  app_name                  = var.app_name
  ecs_ec2_container         = var.ecs_ec2_container
  create                    = length(var.ecs_ec2_container) > 0 ? true: false
  app_port                  = var.app_port
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

  #Existing ECS EC2 Cluster

}

module "ecs_iam_role" {
  source    = "../iam-role"
  create    = length(var.ecs_ec2_container) > 0 ? (length(var.ecs_existing_iam_role) > 0 ? false: true): false
  app_name  = var.app_name
  owners    = var.owners
  projects  = var.projects
  role_type = length(var.ecs_ec2_container) > 0 ? ["ECS"]: []
}

module "ec2_iam_role" {
  source        = "../iam-role"
  create        = length(var.ecs_ec2_container) > 0 ? (length(var.ec2_existing_iam_role) > 0 ? false: true): false
  app_name      = var.app_name
  owners        = var.owners
  projects      = var.projects
  role_type     = length(var.ecs_ec2_container) > 0 ? ["EC2"]: []
  custom_policy = [var.instance_policy]
}

#NOTE we can switch to this style if we can do multiple roles at a time
# module "ecs_iam_role" {
#   source        = "../iam-role"
#   create        = length(var.ecs_ec2_container) > 0 ? true: false
#   app_name      = var.app_name
#   owners        = var.owners
#   projects      = var.projects
#   role_type     = [var.ecs_ec2_container[0]]
#   custom_policy = var.ecs_ec2_container[0] == "EC2" ? [var.instance_policy]: []
# }

