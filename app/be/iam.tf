data "aws_iam_policy_document" "trust" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "this" {

  # statement {
  #   effect = "Allow"
  #   actions = [
  #     "dynamodb:*"
  #   ]
  #   resources = [
  #     "arn:aws:dynamodb:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:table/${var.project}-${var.environment}-*"
  #   ]
  # }

  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:CreateSecret",
      "secretsmanager:UpdateSecret"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "cognito-idp:*"
    ]
    resources = ["arn:aws:cognito-idp:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:userpool/*"]
  }

  statement {
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "ssm:GetParameters"
    ]
    resources = ["*"]
    # resources = data.aws_ssm_parameters_by_path.this.arns
  }

  statement {
    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:DescribeLogGroups",
      "logs:PutRetentionPolicy",
      #      "xray:PutTraceSegments",
      #      "xray:PutTelemetryRecords",
      #      "xray:GetSamplingRules",
      #      "xray:GetSamplingTargets",
      #      "xray:GetSamplingStatisticSummaries",
      #      "cloudwatch:PutMetricData",
      #      "ec2:DescribeVolumes",
      #      "ec2:DescribeTags",
      #      "ssm:GetParameters"
    ]
    resources = ["*"]
  }
    statement {
    sid = "AllowElasticacheActions"
    actions = [
      "elasticache:Describe*",
      "elasticache:ListTagsForResource",
      "elasticache:ModifyCacheParameterGroup",
      "elasticache:RebootCacheCluster",
      "elasticache:Batch*",
      "elasticache:CompleteMigration"
    ]
    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "this" {
  name   = local.name
  policy = data.aws_iam_policy_document.this.json
}


resource "aws_iam_role" "this" {
  name               = local.name
  assume_role_policy = data.aws_iam_policy_document.trust.json
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_role_policy_attachment" "task_execution" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

