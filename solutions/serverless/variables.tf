locals {
  stage         = "training"
  project       = "aws-training"
  function_name = "trump-quote"
  file_name     = "${local.function_name}.zip"
  headers       = "Content-Type, X-Amz-Date, Authorization, X-Api-Key ,X-Amz-Security-Token"
  methods       = "OPTIONS, GET, POST, PUT"
  prefix_env    = terraform.workspace == "default" ? local.stage : terraform.workspace
  prefix        = "${local.project}-${local.prefix_env}"
  default_tags = {
    stage        = local.stage
    project      = local.project
    tf_workspace = terraform.workspace
  }
}
