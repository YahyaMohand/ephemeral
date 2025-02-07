data "aws_ssm_parameters_by_path" "this" {
  path = format("%s/envs", local.path)
}
