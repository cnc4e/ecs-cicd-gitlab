resource "aws_security_group" "gitlab" {
  name        = "${var.pj}-gitlab-sg"
  vpc_id      = var.vpc_id
  description = "For GitLab EC2"

  tags = merge(
    {
      "Name" = "${var.pj}-gitlab-sg"
    },
    var.tags
  )

  dynamic ingress {
    for_each = var.sg_ingresses
    content {
      description = ingress.value["description"]
      from_port   = ingress.value["port"]
      to_port     = ingress.value["port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }

  egress {
    description = "Allow any outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "gitlab_add_runner" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.gitlab_runner.id
  security_group_id        = aws_security_group.gitlab.id
}