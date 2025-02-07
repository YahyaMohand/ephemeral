moved {
  from = module.ecs_cluster.aws_ecs_cluster.this[0]
  to   = aws_ecs_cluster.this
}

resource "aws_ecs_cluster" "this" {
  name = local.name_prefix
}

moved {
  from = module.ecs_cluster.aws_ecs_cluster_capacity_providers.this[0]
  to   = aws_ecs_cluster_capacity_providers.this
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name = aws_ecs_cluster.this.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  dynamic "default_capacity_provider_strategy" {
    for_each = [1]
    content {
      capacity_provider = "FARGATE_SPOT"
      base              = 1
      weight            = 1
    }
  }
}

resource "aws_security_group" "ecs" {
  name        = format("ecs-%s", local.name_prefix)
  description = "internal HTTP"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "ecs_ingress_lb" {
  type              = "ingress"
  security_group_id = aws_security_group.ecs.id
  description       = "Allow HTTP access from the Load Balancer"

  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.lb.id
}

resource "aws_security_group_rule" "ecs_egress" {
  type              = "egress"
  security_group_id = aws_security_group.ecs.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]

  }
}
