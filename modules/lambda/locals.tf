# TODO Add in tag mapping
locals {
  lambda_tags = {
    Terraform   = "true"
    Application = var.app_name
    Owner       = length(var.owners) == 0 ? "Terraform": var.owners[0]
    Project     = length(var.projects) == 0 ? "Terraform-${var.app_name}": var.projects[0]
  }
  /*lifecycle_do-not-touch = {
    prevent_destroy = true
    ignore_changes  = [value]
  }*/
}
