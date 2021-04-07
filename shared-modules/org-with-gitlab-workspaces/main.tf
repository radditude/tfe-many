variable "organization_name" {
  type = string
}

variable "workspace_count" {
  type = number
}

variable "gitlab_token" {
  type = string
}

variable "gitlab_repo" {
  type = string
}

variable "gitlab_branch" {
  type = string
}

resource "tfe_organization" "boring_test_org" {
  name  = var.organization_name
  email = "${var.organization_name}@example.com"
}

resource "tfe_oauth_client" "gitlab_oauth_client" {
  organization     = tfe_organization.boring_test_org.name
  api_url          = "https://gitlab.com/api/v4"
  http_url         = "https://gitlab.com"
  oauth_token      = var.gitlab_token
  service_provider = "gitlab_hosted"
}

resource "tfe_workspace" "boring_workspaces" {
  count        = var.workspace_count
  organization = tfe_organization.boring_test_org.name
  name         = "boring-workspace-${count.index}"
  auto_apply   = true

  vcs_repo {
    identifier     = var.gitlab_repo
    branch         = var.gitlab_branch
    oauth_token_id = tfe_oauth_client.gitlab_oauth_client.oauth_token_id
  }
}
