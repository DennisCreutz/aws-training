variable "stage" {
  description = "The stage name."
  type        = string
}

locals {
  project              = "aws-training"
  lambda_function_name = "${local.prefix}-trump-quote"
  prefix_env           = terraform.workspace == "default" ? var.stage : terraform.workspace
  prefix               = "${local.project}-${local.prefix_env}"
  default_tags = {
    stage        = var.stage
    project      = local.project
    tf_workspace = terraform.workspace
  }
}
