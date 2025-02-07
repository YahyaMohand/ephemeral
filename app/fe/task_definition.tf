resource "aws_ecs_task_definition" "this" {
  family = local.name

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu    = 256
  memory = 512

  task_role_arn      = aws_iam_role.this.arn
  execution_role_arn = aws_iam_role.this.arn

  container_definitions = jsonencode([
    {
      name  = "app"
      image = format("%s:latest", aws_ecr_repository.this.repository_url)

      essential = true

      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
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
    }
  ])
}
