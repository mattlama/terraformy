output "old_vpc_id" {
    value = module.terraformy_new.vpc_id
}

output "old_vpc_public_subents" {
    value = module.terraformy_new.vpc_public_subents
}

output "old_vpc_private_subents" {
    value = module.terraformy_new.vpc_private_subents
}

output "old_security_group_id" {
    value = module.terraformy_new.security_group_id
}

output "new_ecs_cluster_name" {
    value = module.terraformy_new.ecs_cluster_name
}