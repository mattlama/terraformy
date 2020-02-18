# terraformy
A jumbo teraform module designed with the ability to create custom fully built aws infrastructure

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
- ~~IAM Users~~

Functionality will be limited at first to components which I have already used

TODOs
- Reorganize variables to make things easier to find
- Allow more conrtol over the number of created resources (It is limited to 1 in many cases now)
- Add mapping to prevent multiple lists being required to be in sync
- Add in 'use existing' functionality where missing