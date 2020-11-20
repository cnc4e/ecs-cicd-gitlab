resource "aws_security_group" "service" {
  name        = "${var.sg_name}-sg"
  vpc_id      = var.vpc_id
  description = "For ECS service ${var.sg_name}"

  tags = merge(
    {
      "Name" = "${var.sg_name}-sg"
    },
    var.tags
  )

  egress {
    description = "Allow any"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}