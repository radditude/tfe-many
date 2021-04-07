provider "tfe" {
  hostname = var.hostname
  token    = var.tfe_token
}

module "orgs_and_workspaces" {
  source = "../shared-modules/org-with-workspaces"
  count  = var.organization_count

  organization_name = "${var.org_base_name}-${count.index}"
  workspace_count   = var.workspace_count
}
