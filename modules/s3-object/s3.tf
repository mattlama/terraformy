resource "aws_s3_bucket_object" "new_file" {
  count  = length(var.existing_s3_object) > 0 ? 0 : length(var.s3_keys)
  bucket = var.s3_bucket
  key    = var.s3_keys[count.index]
  source = var.s3_filepaths[count.index]
}

data "aws_s3_bucket_object" "current" {
  count  = length(var.existing_s3_object) > 0 ? 1 : 0
  bucket = var.s3_bucket
  key    = var.existing_s3_object[0]
}