#There are different types of Roles with different requirements. Currently limiting Roles created at a time to 1
#ECS task execution role data is used when creating a new role for this ecs service. We grab the existing ecs role policy document and attach it to our new role
data "aws_iam_policy_document" "role_document" {
  count = length(var.role_type) > 0 ? (length(var.custom_policy) > 0 ? 0: 1) : 0
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [var.role_type[0] == "ECS" ? "ecs-tasks.amazonaws.com": (var.role_type[0] == "ASG" ? "application-autoscaling.amazonaws.com": "")]
    }
  }
}

#New elements
resource "aws_iam_role" "new_role" {
  count = length(var.role_type) > 0 ? 1 : 0
  name               = var.role_type[0] == "ECS" ? "${var.app_name}-task-role": (var.role_type[0] == "ASG" ? "${var.app_name}-auto-scale-role": "${var.app_name}-instance-role") 
  assume_role_policy = length(var.custom_policy) > 0 ? var.custom_policy[0]: data.aws_iam_policy_document.role_document[0].json
  tags               = {
    Terraform   = "true"
    Application = var.app_name
    Owner       = var.owners[0]
    Project     = var.projects[0]
  }
}

#Role policy attachment
resource "aws_iam_role_policy_attachment" "role_attachment" {
  count = length(var.role_type) > 0 ? 1 : 0
  role       = aws_iam_role.new_role[0].name
  policy_arn = var.role_type[0] == "ECS" ? "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy": (var.role_type[0] == "ASG" ? "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole": "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role")
}
