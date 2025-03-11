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
