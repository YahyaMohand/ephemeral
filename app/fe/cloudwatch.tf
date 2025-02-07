resource "aws_cloudwatch_log_group" "this" {
  name              = local.path
  retention_in_days = "7"
}
