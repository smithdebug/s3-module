remote_state {
  backend = "s3"
  config {
    encrypt        = true
    bucket         = "terraform-state-backend-jenkins"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl")
}

locals {
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl")
}
