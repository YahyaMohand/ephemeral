resource "aws_security_group" "lb" {
  name        = format("lb-%s", local.name_prefix)
  description = "public HTTP and HTTPS"
  vpc_id      = module.vpc.vpc_id

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_security_group_rule" "lb_ingress_http" {
  type              = "ingress"
  security_group_id = aws_security_group.lb.id
  description       = "Allow HTTP access from the Internet"

  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}


resource "aws_security_group_rule" "lb_ingress_https" {
  type              = "ingress"
  security_group_id = aws_security_group.lb.id
  description       = "Allow HTTPS access from the Internet"

  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "lb_egress" {
  type              = "egress"
  security_group_id = aws_security_group.lb.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

moved {
  from = module.lb.aws_lb.this[0]
  to   = aws_lb.this
}

resource "aws_lb" "this" {
  # name = substr(local.name_prefix, 0, 32)
  name = local.name_prefix

  load_balancer_type = "application"

  subnets         = module.vpc.public_subnets
  security_groups = [aws_security_group.lb.id]

  timeouts {
    create = "10m"
    delete = "10m"
    update = "10m"
  }
  depends_on = [ module.acm ]
}

moved {
  from = module.lb.aws_lb_listener.frontend_http_tcp[0]
  to   = aws_lb_listener.http
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn

  port     = 80
  protocol = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      status_code = "HTTP_301"
      port        = "443"
      protocol    = "HTTPS"
    }
  }
  depends_on = [ module.acm ]
}

moved {
  from = module.lb.aws_lb_listener.frontend_https[0]
  to   = aws_lb_listener.https
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn

  port            = 443
  protocol        = "HTTPS"
  certificate_arn = module.acm[0].acm_certificate_arn
  ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-2021-06"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "404"
      message_body = "Not Found"
    }
  }
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [ module.acm ]
}


resource "aws_lb_listener_rule" "be" {
  count        = var.is_backend ? 1 : 0
  listener_arn = aws_lb_listener.https.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = module.app_be[0].target_group_arn
  }

  condition {
    host_header {
    values =  [
        format("be.%s", local.domains.external_domain)
      ] 
    }
  }
}

resource "aws_lb_listener_rule" "fe" {
  count        = var.is_frontend ? 1 : 0
  listener_arn = aws_lb_listener.https.arn
  priority     = 2

  action {
    type             = "forward"
    target_group_arn = module.app_fe[0].target_group_arn
  }

  condition {
    host_header {
      values = [
        format("fe.%s", local.domains.external_domain)
      ]
    }
  }
}