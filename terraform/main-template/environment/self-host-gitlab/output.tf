output "public_dns" {
  value = module.gitlab.public_dns
}

output "public_ip" {
  value = module.gitlab.public_ip
}

output "runner_sg_id" {
  value = module.gitlab.runner_sg_id
}