resource "aws_appautoscaling_target" "backend_ecs_target" {
  max_capacity       = 10
  min_capacity       = 2
  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.backend.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "backend_ecs_cpu_policy" {
  name               = "backend-ecs-cpu-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.backend_ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.backend_ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.backend_ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    # Scale if CPU Utilization hits 70%
    target_value = 70.0

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    # Want to scale out faster than scale in, can tolerate excess capacity but not lack of capacity
    scale_out_cooldown = 60
    scale_in_cooldown  = 300
  }
}

resource "aws_appautoscaling_policy" "backend_ecs_memory_policy" {
  name               = "backend-ecs-memory-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.backend_ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.backend_ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.backend_ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    # Scale if CPU Utilization hits 70%
    target_value = 70.0

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    # Want to scale out faster than scale in, can tolerate excess capacity but not lack of capacity
    scale_out_cooldown = 60
    scale_in_cooldown  = 300
  }
}

resource "aws_appautoscaling_target" "frontend_ecs_target" {
  max_capacity       = 10
  min_capacity       = 2
  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.frontend.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "frontend_ecs_cpu_policy" {
  name               = "frontend-ecs-cpu-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.frontend_ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.frontend_ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.frontend_ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    # Scale if CPU Utilization hits 70%
    target_value = 70.0

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    # Want to scale out faster than scale in, can tolerate excess capacity but not lack of capacity
    scale_out_cooldown = 60
    scale_in_cooldown  = 300
  }
}

resource "aws_appautoscaling_policy" "frontend_ecs_memory_policy" {
  name               = "frontend-ecs-memory-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.frontend_ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.frontend_ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.frontend_ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    # Scale if CPU Utilization hits 70%
    target_value = 70.0

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    # Want to scale out faster than scale in, can tolerate excess capacity but not lack of capacity
    scale_out_cooldown = 60
    scale_in_cooldown  = 300
  }
}
