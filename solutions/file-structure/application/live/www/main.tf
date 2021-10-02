terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = "~> 3.61"
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
  shared_credentials_file = "../../../../../shared-credentials/aws-shared-credentials"
  profile                 = "myprofile"
}

resource "aws_s3_bucket" "frontend" {
  bucket = "${local.prefix}-the-trump-quoter"
  versioning {
    enabled = false
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  acl = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = local.default_tags
}

# Upload S3 files
resource "aws_s3_bucket_object" "app" {
  for_each = fileset("${path.module}/html", "**")

  bucket       = aws_s3_bucket.frontend.bucket
  key          = each.value
  source       = "${path.module}/html/${each.value}"
  content_type = "text/html"

  acl = "public-read"

  etag = filemd5("${path.module}/html/index.html")

  tags = local.default_tags
}
