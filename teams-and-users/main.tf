# This will produce a whole mess of organizations, teams, and users.
# Each user created will be invited to each organization and added
# to every team in every organization.

# Note that you'll need to manually accept the invitation in order
# to actually use any of the user accounts created.
provider "tfe" {
  hostname = var.hostname
  token    = var.tfe_token
}

resource "tfe_organization" "boring_test_orgs" {
  for_each = local.organizations
  name     = each.value.name
  email    = "${each.value.name}@example.com"
}

resource "tfe_workspace" "boring_workspaces" {
  count        = var.organization_count * var.workspace_count
  organization = tfe_organization.boring_test_orgs["${count.index % var.organization_count}"].name
  name         = "boring-workspace-${count.index}"
}

resource "tfe_team" "boring_teams" {
  for_each     = local.teams
  name         = each.value.name
  organization = each.value.organization
}

resource "tfe_organization_membership" "boring_org_members" {
  for_each     = local.users
  email        = each.value.email
  organization = each.value.organization
}

resource "tfe_team_organization_member" "boring_org_team_members" {
  for_each                   = toset(local.memberships)
  team_id                    = tfe_team.boring_teams["${split(" | ", each.value)[1]}"].id
  organization_membership_id = tfe_organization_membership.boring_org_members["${split(" | ", each.value)[2]}"].id
}

locals {
  total_teams = var.organization_count * var.team_count
  total_users = var.organization_count * var.user_count

  organizations = { for i in range(0, var.organization_count) : i => {
    name = "${var.org_base_name}-${i}"
  } }

  teams = { for i in range(0, local.total_teams) : i => {
    name         = "boring-team-${i}"
    organization = local.organizations[i % var.organization_count].name
  } }

  users = { for i in range(0, local.total_users) : i => {
    email        = "${var.email_base}+provideruser${i}@${var.email_domain}"
    organization = local.organizations[i % var.organization_count].name
  } }

  # for_each only takes a single-level map or a list of strings, so in order to correctly relate each
  # membership to an org, user, and team, this happened
  memberships = flatten([
    for org in range(0, var.organization_count) : [
      for team in range(0, var.team_count) : [
        for user in range(0, var.user_count) : "${org} | ${org + (var.organization_count * team)} | ${org + (var.organization_count * user)}"
      ]
    ]
  ])
}
