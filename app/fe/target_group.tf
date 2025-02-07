resource "aws_lb_target_group" "this" {
  vpc_id = var.dependencies.vpc_id
  name   = local.name

  target_type = "ip"
  port        = 3000
  protocol    = "HTTP"

  deregistration_delay = "0"

  health_check {
    path     = "/"
    interval            = 30  # Check every 30 seconds
    timeout             = 5   # Timeout after 5 seconds
    healthy_threshold   = 3   # Consider healthy after 3 successful checks
    unhealthy_threshold = 3   # Consider unhealthy after 3 failed checks
  }
}

output "target_group_arn" {
  value = aws_lb_target_group.this.arn
}
