# This will produce an arbitrary number of organizations and workspaces
# according to var.organization_count and var.workspace_count. Each
# organization will have an OAuth connection to Gitlab.com and each workspace
# will be hooked up to a single defined Gitlab repository.
provider "tfe" {
  hostname = var.hostname
  token    = var.tfe_token
}

resource "tfe_organization" "boring_test_orgs" {
  for_each = local.organizations
  name     = each.value.name
  email    = "${each.value.name}@example.com"
}

resource "tfe_oauth_client" "gitlab_oauth_clients" {
  count            = var.organization_count
  organization     = tfe_organization.boring_test_orgs[count.index].name
  api_url          = "https://gitlab.com/api/v4"
  http_url         = "https://gitlab.com"
  oauth_token      = var.gitlab_token
  service_provider = "gitlab_hosted"
}

resource "tfe_workspace" "boring_workspaces" {
  count        = var.organization_count * var.workspace_count
  organization = tfe_organization.boring_test_orgs[count.index % var.organization_count].name
  name         = "boring-workspace-${count.index}"
  auto_apply   = true

  vcs_repo {
    identifier     = var.gitlab_repo
    branch         = var.gitlab_branch
    oauth_token_id = tfe_oauth_client.gitlab_oauth_clients[count.index % var.organization_count].oauth_token_id
  }
}

locals {
  organizations = { for i in range(0, var.organization_count) : i => {
    name = "${var.org_base_name}-${i}"
  } }
}
