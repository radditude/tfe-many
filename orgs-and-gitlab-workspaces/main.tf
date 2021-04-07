# This will produce an arbitrary number of organizations and workspaces
# according to var.organization_count and var.workspace_count. Each
# organization will have an OAuth connection to Gitlab.com and each workspace
# will be hooked up to a single defined Gitlab repository.
provider "tfe" {
  hostname = var.hostname
  token    = var.tfe_token
}

module "org_and_workspaces" {
  source = "../shared-modules/org-with-gitlab-workspaces"
  count  = var.organization_count

  organization_name = "${var.org_base_name}-${count.index}"
  workspace_count   = var.workspace_count
  gitlab_token      = var.gitlab_token
  gitlab_repo       = var.gitlab_repo
  gitlab_branch     = var.gitlab_branch
}
