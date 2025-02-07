resource "aws_cloudwatch_log_group" "this" {
  name              = local.path
  retention_in_days = "7"
}

#resource "aws_cloudwatch_log_group" "otel_collector" {
#  name              = format("%s/otel-collector", local.path)
#  retention_in_days = "7"
#}
