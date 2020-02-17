#This is likely a temporary file designed to test different iam role policy ideas
#Ideally I would get a policy passed in but where does the policy come from? User won't create them. I can create ones and have a user choose
#Idea 1: Rendered json
resource "aws_iam_policy" "test_policy" {
  count       = length(var.ecs_ec2_container)
  name        = "instance_policy"
  description = "My test instnace policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

#Idea 2: Variable contains policy
variable "instance_policy" {
  description = "test instance policy"
  default = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
