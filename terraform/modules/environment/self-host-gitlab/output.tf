output "public_dns" {
    value = aws_eip.gitlab.public_dns
}

output "public_ip" {
    value = aws_eip.gitlab.public_ip
}

output "runner_sg_id" {
  value = aws_security_group.gitlab_runner.id
}