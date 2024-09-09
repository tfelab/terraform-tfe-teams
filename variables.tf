variable "tfe_token" {
  description = "The Terraform Cloud API token"
  sensitive   = true
  type        = string
}

variable "org_teams" {
  description = "List of organization teams and their configuration"
  type = list(object({
    name                          = string
    allow_member_token_management = optional(bool, true)
    organization                  = string

    organization_access = optional(object({
      access_secret_teams        = optional(bool, false)
      manage_agent_pools         = optional(bool, false)
      manage_membership          = optional(bool, false)
      manage_modules             = optional(bool, false)
      manage_organization_access = optional(bool, false)
      manage_policies            = optional(bool, false)
      manage_policy_overrides    = optional(bool, false)
      manage_projects            = optional(bool, false)
      manage_providers           = optional(bool, false)
      manage_run_tasks           = optional(bool, false)
      manage_teams               = optional(bool, false)
      manage_vcs_settings        = optional(bool, false)
      manage_workspaces          = optional(bool, false)
      read_projects              = optional(bool, false)
      read_workspaces            = optional(bool, false)
    }), {})

    sso_team_id = optional(string, null)
    visibility  = optional(string, "secret")
  }))

  validation {
    condition = alltrue([
      for team in var.org_teams :
      contains(["organization", "secret"], team.visibility)
    ])
    error_message = "'visibility' must be one of 'organization' or 'secret'."
  }

  default = []
}

variable "org_teams_member" {
  description = "List of organization teams and its members"
  type = object({
    organization = string
    memberships = list(object({
      email = string
      teams = list(string)
    }))
  })

  validation {
    condition     = length(var.org_teams_member.memberships) == length(distinct([for m in var.org_teams_member.memberships : m.email]))
    error_message = "'email' in the 'memberships' list must be unique."
  }

  default = {
    organization = ""
    memberships  = []
  }
}

variable "project_teams_access" {
  description = "List of project teams and defined project permissions"
  type = object({
    organization = string
    teams_projects = list(object({
      access  = optional(list(string), ["read"])
      team    = string
      project = string

      permissions = optional(list(object({
        run_tasks         = bool
        runs              = string
        sentinel_mocks    = string
        state_versions    = string
        variables         = string
        workspace_locking = string
      })), [])

      project_access = optional(list(object({
        settings = optional(string, "read")
        teams    = optional(string, "none")
      })), [])

      workspace_access = optional(list(object({
        create         = optional(bool, false)
        delete         = optional(bool, false)
        locking        = optional(bool, true)
        move           = optional(bool, false)
        run_tasks      = optional(bool, false)
        runs           = optional(string, "apply")
        sentinel_mocks = optional(string, "read")
        state_versions = optional(string, "write")
        variables      = optional(string, "write")
      })), [])
    }))
  })

  validation {
    condition = alltrue([
      for team_project in var.project_teams_access.teams_projects : (
        contains(team_project.access, "custom") ? (
          length(team_project.project_access) > 0 || length(team_project.workspace_access) > 0
        ) : true
      )
    ])

    error_message = "If 'access' contains 'custom', either 'project_access' or 'workspace_access' must be defined."
  }

  default = {
    organization   = ""
    teams_projects = []
  }
}

variable "workspace_teams_access" {
  description = "List of organization teams and defined workspace permissions"
  type = object({
    organization = string
    teams_workspaces = list(object({
      access    = optional(list(string), [])
      team      = string
      workspace = string

      permissions = optional(list(object({
        run_tasks         = bool
        runs              = string
        sentinel_mocks    = string
        state_versions    = string
        variables         = string
        workspace_locking = string
      })), [])
    }))
  })

  validation {
    condition     = alltrue([for tw in var.workspace_teams_access.teams_workspaces : length(tw.access) < 2])
    error_message = "'access' must be either empty or contain only one item."
  }

  validation {
    condition     = alltrue([for tw in var.workspace_teams_access.teams_workspaces : length(tw.permissions) < 2])
    error_message = "'permissions' must be either empty or contain only one item."
  }

  default = {
    organization     = ""
    teams_workspaces = []
  }
}
