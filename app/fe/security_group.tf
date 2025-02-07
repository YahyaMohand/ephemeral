resource "aws_security_group" "this" {
  name        = local.name
  description = format("internal %s", var.application)
  vpc_id      = var.dependencies.vpc_id
}

resource "aws_security_group_rule" "ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.this.id
  description       = "Allow HTTP access from the Load Balancer"

  from_port                = aws_lb_target_group.this.port
  to_port                  = aws_lb_target_group.this.port
  protocol                 = "-1"
  source_security_group_id = var.dependencies.lb_security_group_id
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  security_group_id = aws_security_group.this.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
