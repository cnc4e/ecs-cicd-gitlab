locals {
  default_init_script = <<SHELLSCRIPT
#!/bin/bash

## install Docker
amazon-linux-extras install docker
systemctl enable docker
systemctl start docker

## install GitLab Runner
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh | sudo bash
yum install -y gitlab-runner

usermod -a -G docker gitlab-runner
usermod -a -G docker ec2-user

# グループrunnerの登録
gitlab-runner register \
  --non-interactive \
  --url ${var.ec2_gitlab_url} \
  --registration-token ${var.ec2_registration_token} \
  --name ${var.ec2_runner_name} \
  --tag-list ${join(",", var.ec2_runner_tags)} \
  --run-untagged \
  --executor docker \
  --docker-image docker:stable \
  --docker-privileged \
  --docker-volumes /certs/client

systemctl enable gitlab-runner
systemctl restart gitlab-runner

## Docker resources prune
echo '
[Unit]
Description=GitLab Runner Docker Executor cleanup task

[Service]
Type=simple
ExecStart=/usr/bin/docker system prune --force
User=gitlab-runner
' > /etc/systemd/system/gitlab-runner-docker-executor-cleanup.service

echo '
[Unit]
Description=GitLab Runner Docker Executor cleanup task timer

[Timer]
OnCalendar=*-*-* *:00:00
Unit=gitlab-runner-docker-executor-cleanup.service

[Install]
WantedBy=multi-user.target
' > /etc/systemd/system/gitlab-runner-docker-executor-cleanup.timer

systemctl enable gitlab-runner-docker-executor-cleanup.timer
systemctl start gitlab-runner-docker-executor-cleanup.timer
    SHELLSCRIPT
}

data "aws_ami" "recent_amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_instance" "gitlab_runner" {
  ami                         = data.aws_ami.recent_amazon_linux_2.image_id
  instance_type               = var.ec2_instance_type
  iam_instance_profile        = aws_iam_instance_profile.gitlab_runner.name
  associate_public_ip_address = true
  subnet_id                   = var.ec2_subnet_id
  vpc_security_group_ids      = var.ec2_sg_id != "" ? [var.ec2_sg_id] : [aws_security_group.gitlab_runner.0.id]
  user_data                   = local.default_init_script

  tags = merge(
    {
      "Name" = "${var.pj}-gitlab-runner"
    },
    var.tags
  )

  root_block_device {
    volume_size = var.ec2_root_block_volume_size
  }

  key_name = var.ec2_key_name
}

