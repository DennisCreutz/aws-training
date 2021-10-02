terraform {
  required_version = "~> 1.0"

  required_providers {
    aws     = "~> 3.61"
    archive = "~> 2.2"
  }

  backend "s3" {
    bucket         = "aws-training-global-remote-backend"
    region         = "eu-central-1"
    dynamodb_table = "aws-training-global-remote-backend-db"
    encrypt        = true
  }
}

provider "aws" {
  region                  = "eu-central-1"
  shared_credentials_file = "../../../../../../shared-credentials/aws-shared-credentials"
  profile                 = "myprofile"
}

module "lambda_trump_quote" {
  source = "../../../modules/lambda"

  project = local.project
  stage   = var.stage

  function_name = local.lambda_function_name
  memory_size   = 258
  timeout       = 5
}
