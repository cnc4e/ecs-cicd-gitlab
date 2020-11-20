terraform {
  required_version = ">= 0.13.2"
}

provider "aws" {
  version = ">= 3.5.0"
  region  = "REGION"
}

# inport network value
data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket         = "PJ-NAME-tfstate"
    key            = "network/terraform.tfstate"
    encrypt        = true
    dynamodb_table = "PJ-NAME-tfstate-lock"
    region         = "REGION"
  }
}

data "terraform_remote_state" "preparation" {
  backend = "s3"

  config = {
    bucket         = "PJ-NAME-tfstate"
    key            = "APP-NAME-preparation/terraform.tfstate"
    encrypt        = true
    dynamodb_table = "PJ-NAME-tfstate-lock"
    region         = "REGION"
  }
}

# common parameter settings
locals {
  pj         = "PJ-NAME"
  app        = "APP-NAME"
  app_full   = "${local.pj}-${local.app}"
  vpc_id     = data.terraform_remote_state.network.outputs.vpc_id
  public_subnet_ids  = data.terraform_remote_state.network.outputs.public_subnet_ids
  private_subnet_ids = data.terraform_remote_state.network.outputs.private_subnet_ids
  service_sg_id = data.terraform_remote_state.preparation.outputs.service_sg_id
  tags     = {
    pj     = "PJ-NAME"
    app    = "APP-NAME"
    owner = "OWNER"
  }

  lb_trafic_port       = 80
  lb_traffic_protocol  = "HTTP"
  lb_health_check_path = "/"

  codedeploy_termination_wait_time_in_minutes = 5
}

data "aws_caller_identity" "self" { }
data "aws_region" "current" {}

module "alb" {
  source = "../../../modules/service/service-deploy/alb"

  # common parameter
  app_full = local.app_full
  vpc_id   = local.vpc_id
  tags     = local.tags

  # module parameter
  lb_subnet_ids = local.public_subnet_ids
  lb_service_sg_id = local.service_sg_id
}

module "service" {
  source = "../../../modules/service/service-deploy/ecs-service-fargate"

  # common parameter
  pj       = local.pj
  app      = local.app
  app_full = local.app_full
  vpc_id   = local.vpc_id
  tags     = local.tags

  # module parameter
  ## task definition
  task_execution_role_arn = "arn:aws:iam::${data.aws_caller_identity.self.account_id}:role/${local.pj}-EcsTaskExecuteRole"

  ## service (dummy)
  service_name              = "${local.app_full}-service"
  service_cluster_arn       = "arn:aws:ecs:${data.aws_region.current.name}:${data.aws_caller_identity.self.account_id}:cluster/${local.pj}-cluster"
  service_desired_count     = 1
  service_allow_inbound_sgs = [module.alb.alb_sg_id]
  service_subnets           = local.private_subnet_ids
  service_container_name    = "dummy"
  service_container_port    = 80
  service_sg_id             = local.service_sg_id

  ## ELB Listener & targetgroup
  elb_arn                       = module.alb.alb_arn
  elb_prod_traffic_port         = local.lb_trafic_port
  elb_prod_traffic_protocol     = local.lb_traffic_protocol
  elb_backend_port              = local.lb_trafic_port
  elb_backend_protocol          = local.lb_traffic_protocol
  elb_backend_health_check_path = local.lb_health_check_path

  ## CloudWatch Logs
  clowdwatch_log_groups = ["/${local.pj}-cluster/${local.app_full}-service"]

  depends_on = [module.alb]

}

module "deploy-pipeline" {
  source = "../../../modules/service/service-deploy/deploy-pipeline"

  # common parameter
  # name     = local.pj
  # app      = local.app
  app_full = local.app_full
  vpc_id   = local.vpc_id
  tags     = local.tags

  # module parameter
  # codedeploy
  codedeploy_deployment_group_name            = "${local.app_full}-deploy-group"
  codedeploy_service_role_arn                 = "arn:aws:iam::${data.aws_caller_identity.self.account_id}:role/${local.pj}-CodeDeployRole"
  codedeploy_ecs_cluster_name                 = "${local.pj}-cluster"
  codedeploy_ecs_service_name                 = module.service.ecs_service_name
  codedeploy_prod_listener_arn                = module.service.listener_arn
  codedeploy_blue_target_group_name           = module.service.blue_target_group_name
  codedeploy_green_target_group_name          = module.service.green_target_group_name
  codedeploy_termination_wait_time_in_minutes = local.codedeploy_termination_wait_time_in_minutes

  # S3
  s3_service_settings_bucket_name = local.app_full
  s3_service_settings_bucket_arn  = "arn:aws:s3:::${local.app_full}"
  s3_artifact_store_name          = "${local.app_full}-artifact"

  # codepipeline
  codepipeline_ecr_repository_name = local.app_full
  codepipeline_pipeline_role_arn   = "arn:aws:iam::${data.aws_caller_identity.self.account_id}:role/${local.pj}-CodePipelineRole"

  # cloudwatch event
  cloudwatch_event_ecr_repository_name = local.app_full
  cloudwatch_event_events_role_arn     = "arn:aws:iam::${data.aws_caller_identity.self.account_id}:role/${local.pj}-CloudWatchEventsRole"
  cloudwatch_event_events_role_name    = "${local.pj}-CloudWatchEventsRole"
}
