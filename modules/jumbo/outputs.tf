output "vpc_id" {
    value = module.jumbo_vpc.vpc_id
}

output "vpc_public_subents" {
    value = module.jumbo_vpc.vpc_public_subents
}

output "vpc_private_subents" {
    value = module.jumbo_vpc.vpc_private_subents
}