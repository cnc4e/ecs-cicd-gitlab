resource "aws_lb" "this" {
  name                       = "${var.app_full}-alb"
  load_balancer_type         = "application"
  internal                   = false
  idle_timeout               = 60
  enable_deletion_protection = false
  subnets                    = var.lb_subnet_ids
  security_groups            = [aws_security_group.alb.id]

  tags = merge(
    {
      "Name" = "${var.app_full}-alb"
    },
    var.tags
  )
}