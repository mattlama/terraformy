resource "aws_s3_bucket_object" "new_file" {
  count  = length(var.existing_s3_object) > 0 ? 0 : length(var.s3_objects)
  bucket = lookup(var.s3_objects[count.index], "bucket", "No bucket found")
  key    = lookup(var.s3_objects[count.index], "key", "No Key found")
  source = lookup(var.s3_objects[count.index], "filepath", "No filepath found")
}

data "aws_s3_bucket_object" "current" {
  count  = length(var.existing_s3_object) > 0 ? 1 : 0
  bucket = var.s3_bucket
  key    = var.existing_s3_object[0]
}