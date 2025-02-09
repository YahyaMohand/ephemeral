terraform {
  required_version = ">= 0.14,< 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.74.0"
    }

    sops = {
      source  = "carlpett/sops"
      version = "0.6.3"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
  }


  backend "s3" {
    region                 = "me-south-1"
    skip_region_validation = true
    # dynamodb_table       = "terraform-682033466227"
    bucket               = "terraform-ephemeral-state-bucket"
    workspace_key_prefix = "envs"
    # key                  = "ephemeral-environments/pr-${var.pr_number}/terraform.tfstate"
    acl                  = "bucket-owner-full-control"
    encrypt              = true
  }

}