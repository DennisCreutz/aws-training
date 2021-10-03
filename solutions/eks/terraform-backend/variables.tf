locals {
  stage      = "global"
  project    = "aws-training"
  prefix_env = terraform.workspace == "default" ? local.stage : terraform.workspace
  prefix     = "${local.project}-${local.prefix_env}"
}
