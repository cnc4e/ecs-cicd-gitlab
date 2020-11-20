output "ecs_service_name" {
  value = aws_ecs_service.this.name
}

output "listener_arn" {
  value = aws_lb_listener.prod.arn
}

output "blue_target_group_name" {
  value = aws_lb_target_group.this["${var.app_full}-blue"].name
}

output "green_target_group_name" {
  value = aws_lb_target_group.this["${var.app_full}-green"].name
}
