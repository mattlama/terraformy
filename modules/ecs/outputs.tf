output "ecs_cluster_name" {
    value = aws_ecs_cluster.main[0].name
}

output "ecr_repository_arn" {
    value = aws_ecr_repository.repo[0].arn
}

