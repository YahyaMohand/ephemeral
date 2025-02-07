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

provider "aws" {
  region              = "us-east-1"
  alias               = "us-east-1-no-tags"
  profile             = var.profile
  allowed_account_ids = [var.account_id]
}

provider "aws" {
  region              = "us-east-1"
  alias               = "us-east-1"
  profile             = var.profile
  allowed_account_ids = [var.account_id]

  default_tags {
    tags = local.tags
  }
}


module "app_be" {
  count = var.is_backend ? 1 : 0
  source = "./app/be"

  project     = var.project
  application = "be"
  account_id  = var.account_id

  dependencies = {
    ecs_cluster_name     = aws_ecs_cluster.this.name
    vpc_id               = module.vpc.vpc_id
    lb_security_group_id = aws_security_group.lb.id
    subnet_ids           = module.vpc.public_subnets
  }
}

module "app_fe" {
  count = var.is_frontend ? 1 : 0
  source = "./app/fe"

  project     = var.project
  application = "fe"
  account_id  = var.account_id

  dependencies = {
    ecs_cluster_name     = aws_ecs_cluster.this.name
    vpc_id               = module.vpc.vpc_id
    lb_security_group_id = aws_security_group.lb.id
    subnet_ids           = module.vpc.public_subnets
  }
}

