variable "organization_name" {
  type = string
}

variable "team_count" {
  type = number
}

variable "user_count" {
  type = number
}

variable "email_base" {
  type = string
}

variable "email_domain" {
  type = string
}

variable "team_base_name" {

}

resource "tfe_organization" "boring_test_org" {
  name  = var.organization_name
  email = "${var.organization_name}@example.com"
}

resource "tfe_team" "boring_teams" {
  count        = var.team_count
  name         = "${var.team_base_name}-${count.index}"
  organization = tfe_organization.boring_test_org.name
}

resource "tfe_organization_membership" "boring_org_members" {
  count        = var.user_count
  email        = "${var.email_base}+provideruser${count.index}@${var.email_domain}"
  organization = tfe_organization.boring_test_org.name
}

resource "tfe_team_organization_member" "boring_org_team_members" {
  for_each                   = toset(local.memberships)
  team_id                    = tfe_team.boring_teams[split(" | ", each.value)[0]].id
  organization_membership_id = tfe_organization_membership.boring_org_members[split(" | ", each.value)[1]].id
}

locals {
  # for_each only takes a single-level map or a list of strings, so in order to correctly relate each
  # membership to a user and team, this happened
  memberships = flatten([
    for team in range(0, var.team_count) : [
      for user in range(0, var.user_count) : "${team} | ${user}"
    ]
  ])
}
