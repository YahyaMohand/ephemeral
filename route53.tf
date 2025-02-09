resource "aws_route53_delegation_set" "this" {
  reference_name = local.name_prefix
}

output "delegation_set_name_servers" {
  value = aws_route53_delegation_set.this.name_servers
}

# resource "aws_route53_zone" "this" {
#   name              = local.domains.internal
#   delegation_set_id = aws_route53_delegation_set.this.id
# }


resource "aws_route53_record" "be_A" {
  count = var.is_backend ? 1 : 0
  # zone_id = aws_route53_zone.this.id
  zone_id = "Z044965JQIIKFG"  
  name    = "backend.pr-${var.pr_number}" 
  type    = "A"

  alias {
    zone_id                = aws_lb.this.zone_id
    name                   = aws_lb.this.dns_name
    evaluate_target_health = false
  }
}


resource "aws_route53_record" "fe_A" {
  count = var.is_frontend ? 1 : 0
  # zone_id = aws_route53_zone.this.id
  zone_id = "Z0444624IIKFG"  
  name    = "frontend.pr-${var.pr_number}" 
  type    = "A"

  alias {
    zone_id                = aws_lb.this.zone_id
    name                   = aws_lb.this.dns_name
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "lb_A" {
  # zone_id = aws_route53_zone.this.id
  zone_id = "Z0444624W5965JQIIKFG"  
  name    = "lb"
  type    = "A"

  alias {
    zone_id                = aws_lb.this.zone_id
    name                   = aws_lb.this.dns_name
    evaluate_target_health = false
  }
}
