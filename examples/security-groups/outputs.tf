output "old_vpc_id" {
    value = module.terraformy_existing.vpc_id
}

output "old_vpc_public_subents" {
    value = module.terraformy_existing.vpc_public_subents
}

output "old_vpc_private_subents" {
    value = module.terraformy_existing.vpc_private_subents
}

output "old_security_group_id" {
    value = module.terraformy_existing.security_group_id
}


output "new_vpc_id" {
    value = module.terraformy_new.vpc_id
}

output "new_vpc_public_subents" {
    value = module.terraformy_new.vpc_public_subents
}

output "new_vpc_private_subents" {
    value = module.terraformy_new.vpc_private_subents
}

output "new_security_group_id" {
    value = module.terraformy_new.security_group_id
}