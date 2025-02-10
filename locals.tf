locals {
  project     = var.project
  environment = "pr-${var.pr_number}"

  name_prefix = format("%s-%s", local.project, local.environment)
  

  vpc_cidr = "10.12.0.0/16"
  vpc_azs = ["me-south-1a", "me-south-1b"]

  domains = {
    internal               = format("%s.eph.digitalzone-dev.net", local.environment)
    external_domain        = var.external_domain

    external_domain = "pr-${var.pr_number}.eph.digitalzone-dev.net"
    be_domain      = "be.pr-${var.pr_number}.eph.digitalzone-dev.net"
    fe_domain      = "fe.pr-${var.pr_number}.eph.digitalzone-dev.net"  
 
    }

  tags = {
    CreatedBy = "Terraform"
    Environment = title(local.environment)
    Project     = title(local.project)
  }
}