resource "aws_codedeploy_app" "this" {
  compute_platform = "ECS"
  name             = var.app_full
}

resource "aws_codedeploy_deployment_group" "ecs" {
  app_name               = aws_codedeploy_app.this.name
  deployment_group_name  = var.codedeploy_deployment_group_name
  service_role_arn       = var.codedeploy_service_role_arn
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

  ecs_service {
    cluster_name = var.codedeploy_ecs_cluster_name
    service_name = var.codedeploy_ecs_service_name
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout    = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = var.codedeploy_termination_wait_time_in_minutes
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.codedeploy_prod_listener_arn]
      }

      target_group {
        name = var.codedeploy_blue_target_group_name
      }

      target_group {
        name = var.codedeploy_green_target_group_name
      }

    }
  }
}