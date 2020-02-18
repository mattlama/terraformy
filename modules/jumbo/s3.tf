module "s3_bucket" {
  source          = "../s3-bucket"
  create          = var.create_s3
  existing_bucket = var.existing_s3_bucket
  app_name        = var.app_name
  owners          = var.owners
  projects        = var.projects
}

module "s3_object" {
  source             = "../s3-object"
  s3_bucket          = module.s3_bucket.bucket_name
  s3_keys            = var.s3_object_keys
  s3_filepaths       = var.s3_object_locations
  existing_s3_object = var.existing_s3_object
}
