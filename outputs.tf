output "vpc_id" {
    value = module.vpc.vpc_id
}

output "vpc_public_subents" {
    value = module.vpc.vpc_public_subents
}

output "vpc_private_subents" {
    value = module.vpc.vpc_private_subents
}

output "security_group_id" {
    value = module.security_group.security_group_id
}

output "ecs_cluster_name" {
    value = module.ecs_cluster.ecs_cluster_name
}

output "ecr_repository_arn" {
    value = module.ecs_cluster.ecr_repository_arn
}

output "route53_entries" {
    value = module.routes.route53_entries
}