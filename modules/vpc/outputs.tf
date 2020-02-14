output "vpc_id" {
    value = length(var.existing_vpcs) == 0 ? module.vpc.vpc_id: data.aws_vpc.existing[0].id
}

output "vpc_public_subents" {
    value = length(var.existing_vpcs) == 0 ? module.vpc.public_subnets: data.aws_subnet_ids.public
}

output "vpc_private_subents" {
    value = length(var.existing_vpcs) == 0 ? module.vpc.private_subnets: data.aws_subnet_ids.private
}