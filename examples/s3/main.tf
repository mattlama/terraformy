provider "aws" {
    region                  = var.aws_region
    shared_credentials_file = var.aws_credentials_file_location
    profile                 = var.profile
}

# Use existing S3 bucket add S3 objects
module "terraformy_existing" {
    source     = "../../../terraformy"
    app_name   = "${var.app_name}-old"
    aws_region = var.aws_region
    #Tags
    owners   = ["Test"]
    projects = ["Test-Project"]

    #VPC
    # If using existing VPC only set this:
    existing_vpcs = [var.existing_vpc_id]

    # Note by default security group will attempt to get created. To prevent this add a blank id to existing security group
    existing_security_group = [""]

    #S3 
    # We want to use an existing bucket
    existing_s3_bucket = [var.existing_s3_bucket]
    # Objects are map with bucket, key, and filepath as values. if bucket is a blank string ("") is will use the bucket we just referenced
    s3_objects = [{
        "bucket"   = "",
        "key"      = "test/testfile",
        "filepath" = "./test.txt"
    },
    {
        "bucket"   = "",
        "key"      = "test/testfiles1",
        "filepath" = "./test2.txt"
    }]
}

# Example create new VPC
module "terraformy_new" {
    source     = "../../../terraformy"
    app_name   = "${var.app_name}-old"
    aws_region = var.aws_region
    #Tags
    owners   = ["Test"]
    projects = ["Test-Project"]

    #VPC
    # If using existing VPC only set this:
    existing_vpcs = [var.existing_vpc_id]

    # Note by default security group will attempt to get created. To prevent this add a blank id to existing security group
    existing_security_group = [""]

    #S3 
    # We want to create a new bucket
    create_s3_bucket = true # this will attempt to create a bucket called app_name-guid 
    # Objects are map with bucket, key, and filepath as values. if bucket is a blank string ("") is will use the bucket we just referenced
    # This example will add our test file to the bucket we just made and the existing bucket
    s3_objects = [{
        "bucket"   = "",
        "key"      = "test/testfile-new",
        "filepath" = "./test.txt"
    },
    {
        "bucket"   = var.existing_s3_bucket,
        "key"      = "test/testfile-new",
        "filepath" = "./test.txt"
    }]
}
