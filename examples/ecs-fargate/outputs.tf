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

output "new_ecs_cluster_name" {
    value = module.terraformy_existing.ecs_cluster_name
}