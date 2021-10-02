variable "stage" {
  description = "The stage name."
  type        = string
}

variable "project" {
  description = "The project name."
  type        = string
}

variable "function_name" {
  description = "The Lambda function name."
  type        = string
}

variable "timeout" {
  description = "The Lambda timeout."
  type        = number
}

variable "handler_name" {
  description = "The name of the handler function."
  type        = string
  default     = "index.handler"
}

variable "runtime" {
  description = "The Lambda runtime environment."
  type        = string
  default     = "nodejs14.x"
}

variable "memory_size" {
  description = "Lambda memory size."
  type        = number
  default     = 128
}

locals {
  file_name  = "${var.function_name}.zip"
  prefix_env = terraform.workspace == "default" ? var.stage : terraform.workspace
  prefix     = "${var.project}-${local.prefix_env}"
  default_tags = {
    stage        = var.stage
    project      = var.project
    tf_workspace = terraform.workspace
  }
}
