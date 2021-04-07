# This will produce a whole mess of organizations, teams, and users.
# Each user created will be invited to each organization and added
# to every team in every organization.

# Note that you'll need to manually accept the invitation in order
# to actually use any of the user accounts created.
provider "tfe" {
  hostname = var.hostname
  token    = var.tfe_token
}

module "orgs_with_teams_and_members" {
  source = "../shared-modules/org-with-teams-and-users"
  count  = var.organization_count

  organization_name = "${var.org_base_name}-${count.index}"
  team_base_name    = var.team_base_name
  team_count        = var.team_count
  user_count        = var.user_count
  email_base        = var.email_base
  email_domain      = var.email_domain
}
