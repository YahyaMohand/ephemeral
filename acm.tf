module "acm" {
  count   = var.is_backend || var.is_frontend ? 1 : 0
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 3.0"

  domain_name = local.domains.external_domain
  zone_id     = "Z03930471YQKY02R5MBUA"

  subject_alternative_names = concat(
    var.is_backend ? [local.domains.be_domain] : [],
    var.is_frontend ? [local.domains.fe_domain] : []
  )

  wait_for_validation    = true
  create_route53_records = true
}
