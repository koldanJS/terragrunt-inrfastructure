terraform {
  source = "${include.envcommon.locals.base_source_url}?ref=v0.1.7"
}

include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/green_deployment.hcl"
  expose = true
}

inputs = {
  instance_name = "staging"
  project_name = "GreenDeployTestTerragrunt"
}
