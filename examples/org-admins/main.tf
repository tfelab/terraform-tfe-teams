module "tfe-org-teams" {
  source = "../.."

  tfe_token = var.token

  org_teams = [
    {
      name                          = "admins"
      allow_member_token_management = true
      organization                  = "tfelab"
      organization_access = {
        access_secret_teams        = true
        manage_agent_pools         = true
        manage_membership          = true
        manage_modules             = true
        manage_organization_access = true
        manage_policies            = true
        manage_policy_overrides    = true
        manage_projects            = true
        manage_providers           = true
        manage_run_tasks           = true
        manage_teams               = true
        manage_vcs_settings        = true
        manage_workspaces          = true
        read_projects              = true
        read_workspaces            = true
      }
    }
  ]

  org_teams_member = {
    organization = "tfelab"
    memberships = [
      {
        email = "admin@domain.com"
        teams = [
          "admins"
        ]
      }
    ]
  }
}
