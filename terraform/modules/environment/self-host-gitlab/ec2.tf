data "aws_ami" "recent_gitlab" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["GitLab CE*"]
  }

}

resource "aws_instance" "gitlab" {
  ami                         = var.ec2_ami != null ? var.ec2_ami : data.aws_ami.recent_gitlab.image_id
  instance_type               = var.ec2_instance_type
  associate_public_ip_address = true
  subnet_id                   = var.ec2_subnet_id
  vpc_security_group_ids      = [aws_security_group.gitlab.id]

  tags = merge(
    {
      "Name" = "${var.pj}-gitlab"
    },
    var.tags
  )

  volume_tags = merge(
    {
      "Name" = "${var.pj}-gitlab-ebs"
    },
    var.tags
  )

  root_block_device {
    volume_size = var.ec2_root_block_volume_size
  }

  key_name = var.ec2_key_name
}

