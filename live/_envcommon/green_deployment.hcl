locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env = local.environment_vars.locals.environment
  base_source_url = "git::git@github.com:koldanJS/terragrunt-inrfastructure.git//modules/green_deployment"
}

inputs = {
  project_name  = "test-project-${local.env}"
  instance_type = "t2.micro"
}
