variable "project" {
  type = string
}

variable "environment" {
  type    = string
  default = null
}

variable "application" {
  type = string
}

variable "dependencies" {
  type = object({
    ecs_cluster_name     = string
    vpc_id               = string
    lb_security_group_id = string
    subnet_ids           = list(string)
  })
}

locals {
  name_prefix = var.environment == null ? var.project : format("%s-%s", var.project, var.environment)
  name        = format("%s-%s", local.name_prefix, var.application)
  path        = format("/%s/%s", local.name_prefix, var.application)

  ecr_images_lifetime = 5
}

data "aws_caller_identity" "this" {}

data "aws_region" "this" {}

data "aws_availability_zones" "this" {
  state = "available"

  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }

  filter {
    name   = "region-name"
    values = [data.aws_region.this.name]
  }
}

variable "account_id" {
  type = string
}
