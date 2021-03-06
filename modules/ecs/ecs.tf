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
  # TODO Improve data templates. Network_mode should be awsvpc in the case of an alb and bridge when not
  template = !var.is_web_facing ? (<<EOF
[
  {
    "name": "${var.app_name}-app",
    "image": "${aws_ecr_repository.repo[0].repository_url}",
    "networkMode": "${var.network_mode}",
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
    "name": "${var.app_name}-app",
    "image": "${aws_ecr_repository.repo[0].repository_url}",
    "cpu": ${var.fargate_cpu},
    "memory": ${var.fargate_memory},
    "networkMode": "${var.network_mode}",
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

resource "aws_ecs_service" "main" {
  count           = var.create ? length(var.environments) : 0 
  name            = "${var.app_name}-${var.environments[count.index]}"
  cluster         = aws_ecs_cluster.main[0].id
  task_definition = aws_ecs_task_definition.app[0].arn
  desired_count   = var.container_count
  launch_type     = var.ecs_type[0]

  # Network configuration only needs to exist when 'awsvpc' is the value of the ecs_task_role.network_mode
  dynamic "network_configuration" {
    for_each = var.is_web_facing ? [""] : [] # If web facing create the network configuration block
    content {
      security_groups  = [var.security_group_id]
      subnets          = var.public_subnets
      assign_public_ip = true
    }
  }

  # Load Balancer only needs to exist when 'awsvpc' is the value of the ecs_task_role.network_mode
  dynamic "load_balancer" {
    for_each = var.is_web_facing ? [""] : []
    content {
      target_group_arn = var.target_group_arns[count.index]
      container_name   = "${var.app_name}-app"
      container_port   = var.app_port
    }
  }

  lifecycle {
    ignore_changes = ["desired_count", "task_definition"]
  }
  
  depends_on = [var.alb_listener, var.role_policy_attachment]
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
