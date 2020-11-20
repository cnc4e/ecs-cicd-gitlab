resource "aws_ecs_service" "this" {
  name                              = var.service_name
  cluster                           = var.service_cluster_arn
  task_definition                   = aws_ecs_task_definition.this.arn
  desired_count                     = var.service_desired_count
  launch_type                       = "FARGATE"
  health_check_grace_period_seconds = 60

  network_configuration {
    assign_public_ip = true
    security_groups  = [var.service_sg_id]

    subnets = var.service_subnets
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this["${var.app_full}-blue"].arn
    container_name   = "dummy"
    container_port   = var.service_container_port
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  lifecycle {
    ignore_changes = [task_definition, load_balancer]
  }
}