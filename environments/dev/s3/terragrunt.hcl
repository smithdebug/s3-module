terraform {
    source = "../../../modules//s3"
}

include {
  path = find_in_parent_folders()
}

inputs = {
    bucket_name = "my-project-dev-data"
}