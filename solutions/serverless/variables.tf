locals {
  stage         = "prod"
  project       = "aws-training"
  function_name = "trump-quote"
  file_name     = "${local.function_name}.zip"
  prefix_env    = terraform.workspace == "default" ? local.stage : terraform.workspace
  prefix        = "${local.project}-${local.prefix_env}"
  default_tags = {
    stage        = local.stage
    project      = local.project
    tf_workspace = terraform.workspace
  }
}
