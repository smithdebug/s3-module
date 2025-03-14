remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "terraform-state-backend-jenkins"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "${local.region}"
    
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

}

generate "provider" {
  path = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.region}"
}
EOF
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region       = local.env_vars.locals.aws_region

}
