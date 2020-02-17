variable "s3_bucket" {
  description = "The S3 bucket we will be using"
}

variable "s3_keys" {
  description = "The keys for where the object will end up at in our S3 bucket"
  default     = []
}

variable "s3_filepaths" {
  description = "The locations of the files we want to upload to S3"
  default     = []
}

variable "existing_s3_object" {
  description = "The key of an existing AWS S3 object"
  default     = []
}
