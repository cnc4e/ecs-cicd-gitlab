resource "aws_security_group" "alb" {
  name        = "${var.app_full}-alb-sg"
  vpc_id      = var.vpc_id
  description = "For ${var.app_full} ALB"

  tags = merge(
    {
      "Name" = "${var.app_full}-alb-sg"
    },
    var.tags
  )

  ingress {
    description = "Allow any inbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow any outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "service_allow_lb" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
  security_group_id        = var.lb_service_sg_id
}