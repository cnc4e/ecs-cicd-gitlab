provider "aws" {
  region  = "REGION"
}

# common parameter settings
locals {
  pj   = "PJ-NAME"
  tags = {
    pj     = "PJ-NAME"
    owner = "OWNER"
  }
}

module "gitlab-ecs-cicd-ecs-cluster" {
  source = "../../../modules/environment/ecs-cluster"

  # common parameter
  pj   = local.pj
  tags = local.tags

  # module parameter
  cluster_name = "${local.pj}-cluster"
}

module "code-iam" {
  source = "../../../modules/environment/code-iam"

  # common parameter
  pj   = local.pj
}
