terraform {
  required_version = "~> 1.0"

  required_providers {
    aws     = "~> 3.61"
    archive = "~> 2.2"
  }

  backend "s3" {
    bucket                  = "aws-training-global-remote-backend"
    region                  = "eu-central-1"
    shared_credentials_file = "../../../shared-credentials/aws-shared-credentials"
    profile                 = "myprofile"
    dynamodb_table          = "aws-training-global-remote-backend-db"
    key                     = "live/aws-training/prod/solutions/remote-backend/application/terraform.tfstate"
    encrypt                 = true
  }
}

provider "aws" {
  region                  = "eu-central-1"
  shared_credentials_file = "../../../shared-credentials/aws-shared-credentials"
  profile                 = "myprofile"
}
