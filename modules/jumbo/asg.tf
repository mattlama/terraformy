module "asg" {
  source                    = "../auto-scaling-group"
  app_name                  = var.app_name
  create                    = length(var.ecs_ec2_container) > 0 ? (var.ecs_ec2_container[0] == "EC2" ? true: false): false
  environments              = var.environments
  ecs_cluster_name          = length(var.asg_existing_ecs) > 0 ? var.asg_existing_ecs[0]: module.ecs_cluster.ecs_cluster_name
  auto_scaling_role_iam_arn = length(var.asg_existing_iam_role) > 0 ? var.asg_existing_iam_role[0]: module.asg_iam_role.iam_role_arn
  asg_min_capacity          = var.asg_min_size
  asg_max_capacity          = var.asg_max_size
}

module "asg_iam_role" {
  source    = "../iam-role"
  create    = length(var.ecs_ec2_container) > 0 ? (length(var.asg_existing_iam_role) > 0 ? false: true): false
  app_name  = var.app_name
  owners    = var.owners
  projects  = var.projects
  role_type = length(var.ecs_ec2_container) > 0 ? ["ASG"]: []
}
