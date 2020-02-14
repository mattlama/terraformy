output "vpc_id" {
    value = module.jumbo_new.vpc_id
}

output "vpc_public_subents" {
    value = module.jumbo_new.vpc_public_subents
}

output "vpc_private_subents" {
    value = module.jumbo_new.vpc_private_subents
}

output "vpc_id" {
    value = module.jumbo_old.vpc_id
}

output "vpc_public_subents" {
    value = module.jumbo_old.vpc_public_subents
}

output "vpc_private_subents" {
    value = module.jumbo_old.vpc_private_subents
}