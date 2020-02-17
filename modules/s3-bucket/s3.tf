# Refer here for documentation
# https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws/1.0.0
module "s3-bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  version       = "1.0.0"
  create_bucket = var.create ? (length(var.existing_bucket) > 0 ? false: true) : false
  bucket_prefix = "${var.app_name}"


  tags = {
    Terraform   = "true"
    Application = var.app_name
    Owner       = length(var.owners) == 0 ? "Terraform": var.owners[0]
    Project     = length(var.projects) == 0 ? "Terraform-${var.app_name}": var.projects[0]
  }
}

data "aws_s3_bucket" "current" {
  count  = var.create ? 0 : (length(var.existing_bucket) > 0 ? 1 : 0)
  bucket = var.existing_bucket[0]
}