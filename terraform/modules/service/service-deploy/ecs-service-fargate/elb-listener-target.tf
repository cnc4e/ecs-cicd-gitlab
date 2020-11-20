resource "aws_lb_listener" "prod" {
  load_balancer_arn = var.elb_arn
  port              = var.elb_prod_traffic_port
  protocol          = var.elb_prod_traffic_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this["${var.app_full}-blue"].arn
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [default_action] # for CodeDeploy update
  }
}

resource "aws_lb_target_group" "this" {
  for_each = toset(["${var.app_full}-blue","${var.app_full}-green"])

  name                 = each.value
  target_type          = "ip"
  vpc_id               = var.vpc_id
  port                 = var.elb_backend_port
  protocol             = var.elb_backend_protocol
  deregistration_delay = 30

  health_check {
    path                = var.elb_backend_health_check_path
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 60
    matcher             = 200
    port                = var.elb_backend_port
    protocol            = var.elb_backend_protocol
  }

  tags = merge(
    {
      "Name" = "${each.value}-tg"
    },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_rule" "this" {
  listener_arn = aws_lb_listener.prod.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this["${var.app_full}-blue"].arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  lifecycle {
    ignore_changes = [action] # for CodeDeploy update
  }
}
