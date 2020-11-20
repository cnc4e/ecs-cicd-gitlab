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

# parameter settings
locals {
  pj     = "PJ-NAME"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id
  tags   = {
    pj     = "PJ-NAME"
    owner = "OWNER"
  }

  ec2_subnet_id              = data.terraform_remote_state.network.outputs.public_subnet_ids[0]
  ec2_instance_type          = "t2.large"
  ec2_root_block_volume_size = 30
  ec2_key_name               = ""

  sg_ingresses = [
    {
      port        = 80
      protocol    = "tcp"
      cidr_blocks = ["YOURCIDR"]
      description = "http work pc"
    },
    {
      port        = 22
      protocol    = "tcp"
      cidr_blocks = ["YOURCIDR"]
      description = "ssh work pc"
    }
  ]

  ## 自動スケジュール
  cloudwatch_enable_schedule = false
  cloudwatch_start_schedule  = "cron(0 0 ? * MON-FRI *)"
  cloudwatch_stop_schedule   = "cron(0 10 ? * MON-FRI *)"

  ## 自動スナップショット
  dlm_enable_snapshot = false
  dlm_snaphost_time   = "15:00"
  dlm_snaphost_count  = 1
}

module "gitlab" {
  source = "../../../modules/environment/self-host-gitlab"

  # common parameter
  pj     = local.pj
  tags   = local.tags
  vpc_id = local.vpc_id

  # module parameter
  ec2_instance_type          = local.ec2_instance_type
  ec2_subnet_id              = local.ec2_subnet_id
  ec2_root_block_volume_size = local.ec2_root_block_volume_size
  ec2_key_name               = local.ec2_key_name

  sg_ingresses = local.sg_ingresses

  cloudwatch_enable_schedule = local.cloudwatch_enable_schedule
  cloudwatch_start_schedule  = local.cloudwatch_start_schedule
  cloudwatch_stop_schedule   = local.cloudwatch_stop_schedule

  dlm_enable_snapshot = local.dlm_enable_snapshot
  dlm_snaphost_time   = local.dlm_snaphost_time
  dlm_snaphost_count  = local.dlm_snaphost_count
}
