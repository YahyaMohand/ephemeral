resource "aws_ecs_service" "this" {
  name = var.application

  cluster         = var.dependencies.ecs_cluster_name
  task_definition = aws_ecs_task_definition.this.family

  desired_count = 1

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  enable_execute_command = true

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 100
  }

  network_configuration {
    subnets         = var.dependencies.subnet_ids
    security_groups = [aws_security_group.this.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = "app"
    container_port   = aws_lb_target_group.this.port
  }

  health_check_grace_period_seconds = 60


  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  lifecycle {
    ignore_changes = [
      task_definition,
      desired_count
    ]
  }
}
