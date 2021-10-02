terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = "~> 3.61"
  }
}

provider "aws" {
  region                  = "eu-central-1"
  shared_credentials_file = "../../shared-credentials/aws-shared-credentials"
  profile                 = "myprofile"
}
