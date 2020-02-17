output "object_metadata" {
  value = length(var.existing_s3_object) > 0 ? data.aws_s3_bucket_object.current[0].metadata : aws_s3_bucket_object.new_file[0].metadata
}