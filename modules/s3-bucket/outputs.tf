output "bucket_name" {
  value = length(var.existing_bucket) > 0 ? data.aws_s3_bucket.current[0].id: module.s3-bucket.this_s3_bucket_id
}

output "bucket_arn" {
  value = length(var.existing_bucket) > 0 ? data.aws_s3_bucket.current[0].arn: module.s3-bucket.this_s3_bucket_arn
}
