locals {
  stage               = "prod"
  project             = "aws-training"
  key_name            = "myssh" # SSH key must be created over AWS Console
  vpc_cidr            = "10.0.0.0/20"
  vpc_name            = "${local.prefix}-tf"
  public_subnet_cidrs = ["10.0.0.0/22", "10.0.4.0/22", "10.0.8.0/21"]
  prefix_env          = terraform.workspace == "default" ? local.stage : terraform.workspace
  prefix              = "${local.project}-${local.prefix_env}"
  default_tags = {
    stage        = local.stage
    project      = local.project
    tf_workspace = terraform.workspace
  }
}
