terraform {
    source = "../../../modules//s3_module"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
    bucket_name = "my-project-dev-data"
}