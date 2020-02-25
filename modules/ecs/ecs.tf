resource "aws_ecs_cluster" "main" {
  count = var.create ? 1 : 0
  name  = var.is_ec2 ? "${var.app_name}-ec2-cluster": "${var.app_name}-fargate-cluster"
}

resource "aws_ecr_repository" "repo" {
  count = var.create ? 1 : 0
  name  = var.is_ec2 ? "${var.app_name}-ec2" : "${var.app_name}-fargate"
}

data "template_file" "ecs" {
  count    = var.create ? 1 : 0
  # template = var.is_ec2 ? file("./modules/templates/ecs-ec2.json.tpl"): file("./modules/templates/ecs-fargate.json.tpl")
  # TODO Improve data templates. Network_mode should be awsvpc in the case of an alb and bridge when not
  template = var.is_ec2 ? (<<EOF
[
  {
    "name": "${var.app_name}-app",
    "image": "${aws_ecr_repository.repo[0].repository_url}",
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/${var.app_name}-app",
          "awslogs-region": "${var.aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "environment": [
      {
        "name": "env",
        "value": "%ENV%"
      },
      {
        "name": "AWS_DEFAULT_REGION",
        "value": "${var.aws_region}"
      }
    ]
  }
]
EOF 
): <<EOF
[
  {
    "name": "${var.app_name}",
    "image": "${aws_ecr_repository.repo[0].repository_url}",
    "cpu": ${var.fargate_cpu},
    "memory": ${var.fargate_memory},
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/${var.app_name}-app",
          "awslogs-region": "${var.aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "portMappings": [
      {
        "containerPort": ${var.app_port},
        "hostPort": ${var.app_port}
      }
    ]
  }
]
EOF
  # vars = var.is_ec2 ? {
  #   app_name       = var.app_name
  #   app_image      = aws_ecr_repository.repo[0].repository_url
  #   app_port       = var.app_port
  #   aws_region     = "${var.aws_region}"
  # } : {
  #   app_name       = var.app_name
  #   app_image      = aws_ecr_repository.repo[0].repository_url
  #   app_port       = var.app_port
  #   fargate_cpu    = var.fargate_cpu
  #   fargate_memory = var.fargate_memory
  #   aws_region     = "${var.aws_region}"
  # }
}

resource "aws_ecs_task_definition" "app" {
  count                    = var.create ? 1 : 0
  family                   = "${var.app_name}"
  execution_role_arn       = var.execution_role_arn
  network_mode             = var.network_mode
  requires_compatibilities = [var.ecs_type[0]]
  cpu                      = var.is_ec2 ? "": var.fargate_cpu
  memory                   = var.provisioned_memory
  container_definitions    = data.template_file.ecs[0].rendered
}

resource "aws_ecs_service" "main_fargate" {
  count           = var.create ? (var.is_ec2 ? 0 : length(var.environments)) : 0 
  name            = "${var.app_name}-${var.environments[count.index]}"
  cluster         = aws_ecs_cluster.main[0].id
  task_definition = aws_ecs_task_definition.app[0].arn
  desired_count   = var.container_count
  launch_type     = var.ecs_type[0]

  # Network configuration only needs to exist when 'awsvpc' is the value of the ecs_task_role.network_mode
  network_configuration {
    security_groups  = [var.security_group_id]
    subnets          = var.public_subnets
    assign_public_ip = true
  }
  # TODO bring these services together. Make load_balancer conditional on something other than service type
  load_balancer {
    target_group_arn = var.target_group_arns[count.index]
    container_name   = "${var.app_name}-app"
    container_port   = var.app_port
  }


  depends_on = [var.alb_listener, var.role_policy_attachment]
}

resource "aws_ecs_service" "main_ec2" {
  count           = var.create ? (var.is_ec2 ? length(var.environments): 0) : 0 
  name            = "${var.app_name}-${var.environments[count.index]}"
  cluster         = aws_ecs_cluster.main[0].id
  task_definition = aws_ecs_task_definition.app[0].arn
  desired_count   = var.container_count
  launch_type     = var.ecs_type[0]

  network_configuration {
    security_groups  = [var.security_group_id]
    subnets          = var.public_subnets
  }
}


data "aws_ami" "ecs" {
  count       = var.create ? (var.is_ec2 ? 1 : 0) : 0
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

resource "aws_iam_instance_profile" "instance" {
  count = var.create ? (var.is_ec2 ? 1 : 0) : 0
  name  = "${var.app_name}-instance-profile"
  role  = "${var.instance_role_name}"
}

resource "aws_launch_configuration" "instance" {
  count                = var.create ? (var.is_ec2 ? 1 : 0) : 0
  name_prefix          = "${var.app_name}-lc"
  image_id             = "${data.aws_ami.ecs[0].id}"
  instance_type        = "${var.instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.instance[0].name}"
  security_groups      = [var.security_group_id]
  key_name             = var.key_pair
  user_data = <<EOF
#!/bin/bash
echo "ECS_CLUSTER=${aws_ecs_cluster.main[0].name}" > /etc/ecs/ecs.config
EOF

  root_block_device {
    volume_size = "${var.instance_root_volume_size}"
    volume_type = "gp2"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  count = var.create ? (var.is_ec2 ? 1 : 0) : 0
  name  = "${var.app_name}-asg"

  launch_configuration = "${aws_launch_configuration.instance[0].name}"
  vpc_zone_identifier  = var.public_subnets
  max_size             = "${var.asg_max_size}"
  min_size             = "${var.asg_min_size}"
  desired_capacity     = "${var.asg_desired_size}"

  health_check_grace_period = 300
  health_check_type         = var.ecs_type[0]

  lifecycle {
    create_before_destroy = true
  }
}
