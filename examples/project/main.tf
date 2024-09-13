module "tfe-org-teams" {
  source = "../.."

  tfe_token = var.token

  org_teams = [
    {
      name         = "developers"
      organization = "tfelab"
    },
    {
      name         = "developers-lead"
      organization = "tfelab"
    },
    {
      name                          = "manager"
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
    },
    {
      name         = "platform"
      organization = "tfelab"
    },
    {
      name         = "platform-lead"
      organization = "tfelab"
    }
  ]

  org_teams_member = {
    organization = "tfelab"
    memberships = [
      {
        email = "developer@domain.com"
        teams = [
          "developers"
        ]
      },
      {
        email = "developer-lead@domain.com"
        teams = [
          "developers-lead"
        ]
      },
      {
        email = "manager@domain.com"
        teams = [
          "manager"
        ]
      },
      {
        email = "platform@domain.com"
        teams = [
          "platform"
        ]
      },
      {
        email = "platform-lead@domain.com"
        teams = [
          "platform-lead"
        ]
      }
    ]
  }

  workspace_teams_access = {
    organization = "tfelab"
    teams_workspaces = [
      {
        permissions = [{
          run_tasks         = true
          runs              = "apply"
          sentinel_mocks    = "read"
          state_versions    = "read"
          variables         = "write"
          workspace_locking = false
        }]

        team      = "developers"
        workspace = "ecommerce-sit-aws"
      },
      {
        permissions = [{
          run_tasks         = true
          runs              = "apply"
          sentinel_mocks    = "read"
          state_versions    = "write"
          variables         = "write"
          workspace_locking = true
        }]

        team      = "developers-lead"
        workspace = "ecommerce-sit-aws"
      },
      {
        access    = ["write"]
        team      = "platform"
        workspace = "ecommerce-dev-aws"
      },
      {
        access    = ["admin"]
        team      = "platform-lead"
        workspace = "ecommerce-dev-aws"
      }
    ]
  }

  project_teams_access = {
    organization = "tfelab"
    teams_projects = [
      {
        access  = ["admin"]
        team    = "developers-lead"
        project = "ecommerce"
      },
      {
        access  = ["custom"]
        team    = "platform-lead"
        project = "ecommerce"
        project_access = [
          {
            settings = "update"
            teams    = "manage"
          }
        ]
      }
    ]
  }
}
