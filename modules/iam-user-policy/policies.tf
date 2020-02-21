resource "aws_iam_user_policy" "user_ecs" {
  count = length(var.user_policies)
  name  = "${var.user_policies[count.index]}-${var.app_name}" #"ECS"
  user  = var.user #"${aws_iam_user.user.name}"

  policy = var.user_policies[count.index] == "ECS"? (<<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
EOF
): (var.ecr_repository_arn == "" ? "": <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ecr:GetLifecyclePolicyPreview",
                "ecr:GetDownloadUrlForLayer",
                "ecr:ListTagsForResource",
                "ecr:BatchDeleteImage",
                "ecr:UploadLayerPart",
                "ecr:ListImages",
                "ecr:DeleteLifecyclePolicy",
                "ecr:PutImage",
                "ecr:BatchGetImage",
                "ecr:CompleteLayerUpload",
                "ecr:DescribeImages",
                "ecr:TagResource",
                "ecr:DescribeRepositories",
                "ecr:InitiateLayerUpload",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetLifecyclePolicy",
                "ecr:GetRepositoryPolicy"
            ],
            "Resource": "${var.ecr_repository_arn}"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "ecr:GetAuthorizationToken",
            "Resource": "*"
        }
    ]
}
EOF
)
}
