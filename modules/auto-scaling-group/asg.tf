data "aws_iam_role" "ecs_autoscale_role" {
  name = "AWSServiceRoleForApplicationAutoScaling_ECSService"
}

resource "aws_appautoscaling_target" "target" {
  count              = var.create ? length(var.environments): 0
  service_namespace  = "ecs"
  resource_id        = "service/${var.ecs_cluster_name}/${var.app_name}-${var.environments[count.index]}"
  scalable_dimension = "ecs:service:DesiredCount"
  role_arn           = data.aws_iam_role.ecs_autoscale_role.arn #var.auto_scaling_role_iam_arn 
  min_capacity       = var.asg_min_capacity
  max_capacity       = var.asg_max_capacity
}

# Automatically scale capacity up by one
resource "aws_appautoscaling_policy" "up" {
  count              = var.create ? (var.add_asg_policies ? length(var.environments): 0) : 0
  name               = "${var.app_name}_scale_up"
  service_namespace  = "ecs"
  resource_id        = "service/${var.ecs_cluster_name}/${var.app_name}-${var.environments[count.index]}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }

  depends_on = [aws_appautoscaling_target.target]
}

# Automatically scale capacity down by one
resource "aws_appautoscaling_policy" "down" {
  count              = var.create ? (var.add_asg_policies ? length(var.environments): 0) : 0
  name               = "${var.app_name}_scale_down"
  service_namespace  = "ecs"
  resource_id        = "service/${var.ecs_cluster_name}/${var.app_name}-${var.environments[count.index]}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = [aws_appautoscaling_target.target]
}

# CloudWatch alarm that triggers the autoscaling up policy
resource "aws_cloudwatch_metric_alarm" "service_cpu_high" {
  count               = var.create ? (var.add_cpu_policies ? length(var.environments): 0) : 0
  alarm_name          = "${var.app_name}_cpu_utilization_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "85"

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = "${var.app_name}-${var.environments[count.index]}"
  }

  alarm_actions = [aws_appautoscaling_policy.up[count.index].arn]
}

# CloudWatch alarm that triggers the autoscaling down policy
resource "aws_cloudwatch_metric_alarm" "service_cpu_low" {
  count               = var.create ? (var.add_cpu_policies ? length(var.environments): 0) : 0
  alarm_name          = "${var.app_name}_cpu_utilization_low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = "${var.app_name}-${var.environments[count.index]}"
  }

  alarm_actions = [aws_appautoscaling_policy.down[count.index].arn]
}

