variable "organization_name" {
  type = string
}

variable "workspace_count" {
  type = number
}

resource "tfe_organization" "boring_test_org" {
  name  = var.organization_name
  email = "${var.organization_name}@example.com"
}

resource "tfe_workspace" "boring_workspaces" {
  count        = var.workspace_count
  organization = tfe_organization.boring_test_org.name
  name         = "boring-workspace-${count.index}"
  auto_apply   = true
}
