# terraformy
A large terraform module designed with the ability to create custom fully built aws infrastructure. The goal for this project is to be able to use this once per microservice and reduce duplicated terraform code. Should this become simple enough to use the goal is then to put an easy to use web interface or cli in front of it. 

## Components which can be created
- VPC
- Security group
- Autoscaling groups
- ECS Cluster (EC2)
- ECS Cluster (Fargate)
- Lambda
- SSM Parameter store parameters
- S3 bucket/object
- ALB
- Route53 entries
- IAM Users

Functionality will be limited at first to components which I have already used

## How to use
#### VPCs
VPC generation uses the aws module found [here](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/2.9.0).
This project assumes (perhaps incorrectly) that a VPC will always be present. With that assumption in mind terraformy will attempt to create a new VPC if no existing VPC ID is provided. Should the user not want to create a new VPC or use an existing one they are able to do so by providing an existing VPC ID equal to a blank string
```
existing_vpcs = [""] # Will not create a new VPC or use existing
existing_vpcs = ["vpc-123456789"] # Will get the vpc id and public/private subnets for the VPC ID provided and use throughout the module
existing_vpcs = [] # This is the default value. When this is set the module will attempt to create a new VPC
# If we want to create a new VPC we can customize the VPC by setting the following fields
cidr_block
availability_zones
private_subnets
public_subnets
# There are more optional fields which can be found in variables.tf
```
An example of VPC creation can be found [here](https://github.com/mattlama/terraformy/tree/master/examples/vpc)

#### Security Groups
Security Group generation uses the aws module found [here](https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/3.1.0).
Security Groups will by default use the VPC created/provided in the module. The Security Group found here will be used by terraformy for the rest of the modules as needed
```
existing_security_group = [] # Create a new Security Group
existing_security_group = [""] # Do not create a new Security Group and do not use an existing Security Group
existing_security_group = ["sg-123456789"] # Will attempt to use the Security group with the provided id
# If we want to create a new Security Group we can customize it by setting the following fields
ingress_rules
ingress_cidr_blocks
egress_rules
egress_cidr_blocks
```
An example of Security Group creation can be found [here](https://github.com/mattlama/terraformy/tree/master/examples/security-groups)

#### ECS Cluster
ECS creation still needs more work done to it. Currently it works by setting `ecs_type` to either "FARGATE" or "EC2" and it will attempt to create a cluster using the VPC and Security Groups used above. If no VPC was provided then no ECS cluster will be created
```
ecs_type = [] # Default. Will not create a cluster
ecs_type = ["EC2"] # Creates an EC2 cluster
ecs_type = ["FARGATE"] # Creates a FARGATE cluster
# There are many fields which can be set and they are likely to change before long so see examples for customizable fields
```
Examples of ECS creation can be found for [FARGATE here](https://github.com/mattlama/terraformy/tree/master/examples/ecs-fargate) and [EC2 here](https://github.com/mattlama/terraformy/tree/master/examples/ecs-ec2).

#### SSM Parameter store
SSP Parameter store generation works by populating the `parameters` map with 4 required values for each parameter: `name`, `description`, `type` and `value`.  A number of different ways to set `parameters` are supported including a technique for hiding sensitive values.
Examples of SSM Parameter store creation can be found [here](https://github.com/mattlama/terraformy/tree/master/examples/parameter-store).

#### S3
S3 buckets can be created and files added to new or existing buckets easily.  The key actions are `existing_3s_bucket` or `create_s3_bucket` indicating
whether resources are added to an existing or new bucket respectively.
```
create_s3_bucket = true
s3_objects = [{
    "bucket" = "",
    "key" = "test/testfile-x",
    "filepath" = "./testfile-x.txt"
}]
existing_s3_bucket = [var.existing_s3_bucket]
s3_objects = [{
    "bucket" = "", # empty string indicates the referenced bucket is to be used
    "key" = "test/testfile-y",
    "filepath" = "./testfile-y.txt"
}]
```
Examples of S3 can be found [here](https://github.com/mattlama/terraformy/tree/master/examples/s3).


TODOs
- Reorganize variables to make things easier to find
- Allow more control over the number of created resources (It is limited to 1 in many cases now)
- Add in 'use existing' functionality where missing