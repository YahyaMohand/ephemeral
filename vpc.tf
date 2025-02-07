module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.16.0"

  create_vpc = true

  name = local.name_prefix
  cidr = local.vpc_cidr
  azs  = local.vpc_azs

  enable_ipv6 = false

  private_subnets     = [for i, _ in local.vpc_azs : cidrsubnet(local.vpc_cidr, 8, 70 + i)]
  public_subnets      = [for i, _ in local.vpc_azs : cidrsubnet(local.vpc_cidr, 8, 80 + i)]

  enable_vpn_gateway     = false
  enable_nat_gateway     = false
  reuse_nat_ips          = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    Tier = "Public"
  }

  private_subnet_tags = {
    Tier = "Private"
  }

  database_subnet_tags = {
    Tier = "Database"
  }
}
