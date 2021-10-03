terraform {
  required_version = "~> 1.0"

  required_providers {
    aws        = "~> 3.61"
    kubernetes = ">= 1.11.1"
    local      = ">= 1.4"
    cloudinit  = ">= 2.2.0"
  }

  backend "s3" {
    bucket                  = "aws-training-global-remote-backend"
    region                  = "eu-central-1"
    shared_credentials_file = "../../../shared-credentials/aws-shared-credentials"
    profile                 = "myprofile"
    dynamodb_table          = "aws-training-global-remote-backend-db"
    key                     = "live/aws-training/prod/solutions/eks/application/terraform.tfstate"
    encrypt                 = true
  }
}

provider "aws" {
  region                  = "eu-central-1"
  shared_credentials_file = "../../../shared-credentials/aws-shared-credentials"
  profile                 = "myprofile"
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.20.0"
  cluster_name    = local.cluster_name
  cluster_version = "1.20"
  subnets         = module.vpc.private_subnets

  vpc_id = module.vpc.vpc_id

  node_groups_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 20
  }

  node_groups = {
    small = {
      desired_capacity = 1
      max_capacity     = 3
      min_capacity     = 1

      instance_types = ["t3.medium"]
      k8s_labels     = local.default_tags
      update_config = {
        max_unavailable = 1
      }
    }
  }

  worker_create_cluster_primary_security_group_rules = true

  map_roles = local.map_roles
  map_users = local.map_users

  tags = local.default_tags
}
