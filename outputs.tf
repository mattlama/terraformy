output "vpc_id" {
    value = module.jumbo_vpc.vpc_id
}

output "vpc_public_subents" {
    value = module.jumbo_vpc.vpc_public_subents
}

output "vpc_private_subents" {
    value = module.jumbo_vpc.vpc_private_subents
}

output "security_group_id" {
    value = module.security_group.security_group_id
}

output "ecs_cluster_name" {
    value = module.ecs_cluster.ecs_cluster_name
}