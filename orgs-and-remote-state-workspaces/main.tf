# This will produce an arbitrary number of organizations and workspaces
# according to var.organization_count and var.workspace_count. Each
# organization will have an OAuth connection to Github.com and each workspace
# will be hooked up to a single defined Github repository.

# The main branch of that repository contains a Terraform config with a couple
# of outputs; this is used to create the remote state output workspaces.
# The github_branch variable should point at a branch that has one or more
# terraform_remote_state data sources configured, using variables in the remote
# backend config. Then Terraform will create variables to randomly decide
# which output workspaces each data source workspace will read state from.
provider "tfe" {
  hostname = var.hostname
  token    = var.tfe_token
}

module "org_and_workspaces" {
  source = "../shared-modules/org-with-remote-state-workspaces"
  count  = var.organization_count

  organization_name = "${var.org_base_name}-${count.index}"
  workspace_count   = var.workspace_count
  github_token      = var.github_token
  github_repo       = var.github_repo
  github_branch     = var.github_branch
  hostname          = var.hostname
}
