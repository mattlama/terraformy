variable "user_policies" {
    description = "A slice of policies a user wants to create. Currently accepts values of 'ECS' and 'ECR'"
}

variable "user" {
    description = "The user we want to attach a policy to"
}

variable "ecr_repository_arn" {
    description = "The repository arn for when a user needs ecr permissions"
}

variable "app_name" {
    description = "The name of our application"
}
