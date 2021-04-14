variable "organization_name" {
  type = string
}

variable "workspace_count" {
  type = number
}

variable "github_token" {
  type = string
}

variable "github_repo" {
  type = string
}

variable "github_branch" {
  type = string
}

variable "hostname" {
  type = string
}

resource "tfe_organization" "boring_test_org" {
  name  = var.organization_name
  email = "${var.organization_name}@example.com"
}

resource "tfe_oauth_client" "github_oauth_client" {
  organization     = tfe_organization.boring_test_org.name
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = var.github_token
  service_provider = "github"
}

resource "tfe_workspace" "output_workspaces" {
  count          = var.workspace_count
  organization   = tfe_organization.boring_test_org.name
  name           = "output-workspace-${count.index}"
  auto_apply     = true
  queue_all_runs = true

  vcs_repo {
    identifier     = var.github_repo
    oauth_token_id = tfe_oauth_client.github_oauth_client.oauth_token_id
  }
}

resource "tfe_workspace" "data_source_workspaces" {
  count          = var.workspace_count
  organization   = tfe_organization.boring_test_org.name
  name           = "data-source-workspace-${count.index}"
  auto_apply     = true
  queue_all_runs = false

  vcs_repo {
    identifier     = var.github_repo
    branch         = var.github_branch
    oauth_token_id = tfe_oauth_client.github_oauth_client.oauth_token_id
  }
}

resource "tfe_variable" "hostname" {
  count        = var.workspace_count
  key          = "hostname"
  value        = var.hostname
  category     = "terraform"
  workspace_id = tfe_workspace.data_source_workspaces[count.index].id
}

resource "tfe_variable" "organization" {
  count        = var.workspace_count
  key          = "organization"
  value        = tfe_organization.boring_test_org.name
  category     = "terraform"
  workspace_id = tfe_workspace.data_source_workspaces[count.index].id
}

resource "random_integer" "workspace_0" {
  count = var.workspace_count
  min   = 0
  max   = var.workspace_count - 1
}

resource "tfe_variable" "workspace_0" {
  count        = var.workspace_count
  key          = "workspace_0"
  value        = "output-workspace-${random_integer.workspace_0[count.index].id}"
  category     = "terraform"
  workspace_id = tfe_workspace.data_source_workspaces[count.index].id
}

resource "random_integer" "workspace_1" {
  count = var.workspace_count
  min   = 0
  max   = var.workspace_count - 1
}

resource "tfe_variable" "workspace_1" {
  count        = var.workspace_count
  key          = "workspace_1"
  value        = "output-workspace-${random_integer.workspace_1[count.index].id}"
  category     = "terraform"
  workspace_id = tfe_workspace.data_source_workspaces[count.index].id
}
