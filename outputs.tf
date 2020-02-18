output "new_vpc_id" {
    value = module.jumbo_new.vpc_id
}

output "new_vpc_public_subents" {
    value = module.jumbo_new.vpc_public_subents
}

output "new_vpc_private_subents" {
    value = module.jumbo_new.vpc_private_subents
}

# output "old_vpc_id" {
#     value = module.jumbo_old.vpc_id
# }

# output "old_vpc_public_subents" {
#     value = module.jumbo_old.vpc_public_subents
# }

# output "old_vpc_private_subents" {
#     value = module.jumbo_old.vpc_private_subents
# }
