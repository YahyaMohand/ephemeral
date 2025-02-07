resource "aws_ecs_task_definition" "this" {
  family = local.name

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu    = 1024
  memory = 2048

  task_role_arn      = aws_iam_role.this.arn
  execution_role_arn = aws_iam_role.this.arn

  container_definitions = jsonencode([
    {
      name  = "app"
      image = format("%s:latest", aws_ecr_repository.this.repository_url)

      essential = true

      portMappings = [
        {
          containerPort = aws_lb_target_group.this.port
          hostPort      = aws_lb_target_group.this.port
          protocol      = "tcp"
          name          = "app-3000-tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.this.name
          "awslogs-region"        = data.aws_region.this.name
          "awslogs-stream-prefix" = "ecs"
        }
      }

      secrets = [
        for i, v in data.aws_ssm_parameters_by_path.this.arns : {
          name      = reverse(split("/", v))[0]
          valueFrom = v
        }
      ]
    },
    #    {
    #      name  = "otel-collector",
    #      image = "amazon/aws-otel-collector",
    #
    ##      command   = ["--config=/etc/ecs/container-insights/otel-task-metrics-config.yaml"],
    #      essential = true,
    #
    #      logConfiguration = {
    #        logDriver = "awslogs",
    #        options   = {
    #          awslogs-group         = aws_cloudwatch_log_group.otel_collector.name,
    #          awslogs-region        = data.aws_region.this.name,
    #          awslogs-stream-prefix = "ecs",
    #        }
    #      },
    #
    #      healthCheck = {
    #        command     = ["/healthcheck"],
    #        interval    = 5,
    #        timeout     = 6,
    #        retries     = 5,
    #        startPeriod = 1
    #      },
    #
    #      secrets = [
    #        {
    #          name      = "AOT_CONFIG_CONTENT"
    #          valueFrom = "otel-collector-config"
    #        }
    #      ]
    #    },
  ])
}
