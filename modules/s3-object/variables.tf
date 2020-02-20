variable "s3_bucket" {
  description = "The S3 bucket we will be using"
}

variable "existing_s3_object" {
  description = "The key of an existing AWS S3 object"
}

variable "s3_objects" {
  description = "Mapping of the s3 objects we want to create with the fields 'bucket', 'key', and 'filepath'"
}
