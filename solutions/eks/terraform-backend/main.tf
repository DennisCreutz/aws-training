terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = "~> 3.61"
  }
}

provider "aws" {
  region                  = "eu-central-1"
  shared_credentials_file = "../../../shared-credentials/aws-shared-credentials"
  profile                 = "myprofile"
}

module "tf_backend" {
  source = "git::https://github.com/DennisCreutz/terraform-aws-remote-backend.git?ref=1.0.2"

  project = local.project
  stage   = local.stage

  bucket_name    = "${local.prefix}-remote-backend"
  dynamo_db_name = "${local.prefix}-remote-backend-db"
}
