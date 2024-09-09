###############################
# CREATE TEAMS
###############################

resource "tfe_team" "this" {
  for_each = { for team in var.org_teams : team.name => team }

  name                          = each.value.name
  allow_member_token_management = each.value.allow_member_token_management
  organization                  = each.value.organization

  # WHEN DEFINED, SETS ORG LEVEL ACCESS
  dynamic "organization_access" {
    for_each = length([for key, value in each.value.organization_access : key if value != false]) > 0 ? [each.value.organization_access] : []
    content {
      access_secret_teams        = organization_access.value.access_secret_teams
      manage_agent_pools         = organization_access.value.manage_agent_pools
      manage_membership          = organization_access.value.manage_membership
      manage_modules             = organization_access.value.manage_modules
      manage_organization_access = organization_access.value.manage_organization_access
      manage_policies            = organization_access.value.manage_policies
      manage_policy_overrides    = organization_access.value.manage_policy_overrides
      manage_projects            = organization_access.value.manage_projects
      manage_providers           = organization_access.value.manage_providers
      manage_run_tasks           = organization_access.value.manage_run_tasks
      manage_teams               = organization_access.value.manage_teams
      manage_vcs_settings        = organization_access.value.manage_vcs_settings
      manage_workspaces          = organization_access.value.manage_workspaces
      read_projects              = organization_access.value.read_projects
      read_workspaces            = organization_access.value.read_workspaces
    }
  }

  sso_team_id = each.value.sso_team_id
  visibility  = each.value.visibility
}

###############################
# INVITE USER & SET TEAMS MEMBERSHIP
###############################

resource "tfe_organization_membership" "this" {
  for_each = { for user in var.org_teams_member.memberships : user.email => user }

  email        = each.value.email
  organization = var.org_teams_member.organization
}

locals {
  org_teams_memberships = flatten([
    for membership in var.org_teams_member.memberships : [
      for team in membership.teams : {
        organization            = var.org_teams_member.organization
        organization_membership = try(tfe_organization_membership.this[membership.email].id, null)
        email                   = membership.email
        team                    = team
        team_id                 = try(tfe_team.this[team].id, null)
      }
    ]
  ])
}

resource "tfe_team_organization_member" "this" {
  for_each = {
    for entry in local.org_teams_memberships :
    "${entry.team}-${entry.email}" => entry
  }

  team_id                    = each.value.team_id
  organization_membership_id = each.value.organization_membership
}

###############################
# SET WORKSPACE LEVEL ACCESS
###############################

data "tfe_workspace" "this" {
  for_each = {
    for entry in var.workspace_teams_access.teams_workspaces :
    "${var.workspace_teams_access.organization}-${entry.team}-${entry.workspace}" => entry
  }

  name         = each.value.workspace
  organization = var.workspace_teams_access.organization
}

resource "tfe_team_access" "this" {
  for_each = {
    for entry in var.workspace_teams_access.teams_workspaces :
    "${var.workspace_teams_access.organization}-${entry.team}-${entry.workspace}" => entry
  }

  access = length(each.value.access) > 0 ? join("", each.value.access) : null

  dynamic "permissions" {
    for_each = length(each.value.permissions) > 0 ? each.value.permissions : []

    content {
      run_tasks         = permissions.value.run_tasks
      runs              = permissions.value.runs
      sentinel_mocks    = permissions.value.sentinel_mocks
      state_versions    = permissions.value.state_versions
      variables         = permissions.value.variables
      workspace_locking = permissions.value.workspace_locking
    }
  }

  team_id      = try(tfe_team.this[each.value.team].id, null)
  workspace_id = data.tfe_workspace.this["${var.workspace_teams_access.organization}-${each.value.team}-${each.value.workspace}"].id
}

###############################
# SET PROJECT LEVEL ACCESS
###############################

data "tfe_project" "this" {
  for_each = {
    for entry in var.project_teams_access.teams_projects :
    "${var.project_teams_access.organization}-${entry.team}-${entry.project}" => entry
  }

  name         = each.value.project
  organization = var.project_teams_access.organization
}

resource "tfe_team_project_access" "this" {
  for_each = {
    for entry in var.project_teams_access.teams_projects :
    "${var.project_teams_access.organization}-${entry.team}-${entry.project}" => entry
  }

  access = join("", each.value.access)

  dynamic "project_access" {
    for_each = length(each.value.project_access) > 0 ? each.value.project_access : []

    content {
      settings = project_access.value.settings
      teams    = project_access.value.teams
    }
  }

  dynamic "workspace_access" {
    for_each = length(each.value.workspace_access) > 0 ? each.value.workspace_access : []

    content {
      create         = workspace_access.value.create
      delete         = workspace_access.value.delete
      locking        = workspace_access.value.locking
      move           = workspace_access.value.move
      run_tasks      = workspace_access.value.run_tasks
      runs           = workspace_access.value.runs
      sentinel_mocks = workspace_access.value.sentinel_mocks
      state_versions = workspace_access.value.state_versions
      variables      = workspace_access.value.variables
    }
  }

  team_id    = try(tfe_team.this[each.value.team].id, null)
  project_id = data.tfe_project.this["${var.project_teams_access.organization}-${each.value.team}-${each.value.project}"].id
}
