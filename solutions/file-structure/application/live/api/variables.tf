variable "stage" {
  description = "The stage name."
  type        = string
}

variable "lambda_remote_key" {
  description = "The key to the Lambda remote state."
  type        = string
}

locals {
  project    = "aws-training"
  prefix_env = terraform.workspace == "default" ? var.stage : terraform.workspace
  prefix     = "${local.project}-${local.prefix_env}"
  default_tags = {
    stage        = var.stage
    project      = local.project
    tf_workspace = terraform.workspace
  }
}
