locals {
  stage        = "prod"
  project      = "aws-training"
  cluster_name = "${local.prefix}-k8s"
  prefix_env   = terraform.workspace == "default" ? local.stage : terraform.workspace
  prefix       = "${local.project}-${local.prefix_env}"
  default_tags = {
    stage        = local.stage
    project      = local.project
    tf_workspace = terraform.workspace
  }
  map_roles = [
    {
      rolearn  = "arn:aws:iam::190822135932:role/AWSReservedSSO_AWSAdministratorAccess_ee1be70e271d663d"
      username = "sso-admin-role-usr"
      groups   = ["system:masters"]
    },
  ]
  map_users = []
}
