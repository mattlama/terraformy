resource "aws_iam_user" "user" {
  count = length(var.users) > 0 ? 1 : 0
  name  = lookup(var.users[count.index], "name", "") == "" ? "${var.app_name}-devops": var.users[count.index]["name"]
  tags  = {
    Terraform   = "true"
    Application = var.app_name
    Owner       = length(var.owners) == 0 ? "Terraform": var.owners[0]
    Project     = length(var.projects) == 0 ? "Terraform-${var.app_name}": var.projects[0]
  }
}

resource "aws_iam_access_key" "user" {
  count = length(var.users) > 0 ? 1 : 0
  user  = "${aws_iam_user.user[count.index].name}"
}

module "iam_user_policies" {
  source = "../iam-user-policy"
  user               = length(var.users) > 0 ? lookup(var.users[0], "name", ""): ""
  user_policies      = length(var.users) > 0 ? lookup(var.users[0], "policies", []): []
  ecr_repository_arn = var.ecr_repository_arn
  app_name           = var.app_name
}