module "tfe-org-teams" {
  source = "../.."

  tfe_token = var.token

  org_teams = [
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
        email = "myemail@domain.com"
        teams = [
          "platform"
        ]
      },
      {
        email = "myemail2@domain.com"
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
}
