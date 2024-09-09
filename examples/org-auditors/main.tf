module "tfe-org-teams" {
  source = "../.."

  tfe_token = var.token

  org_teams = [
    {
      name                          = "auditors"
      allow_member_token_management = false
      organization                  = "tfelab"
      organization_access = {
        read_projects   = true
        read_workspaces = true
      }
    },
  ]

  org_teams_member = {
    organization = "tfelab"
    memberships = [
      {
        email = "myemail@domain.com"
        teams = [
          "auditors"
        ]
      }
    ]
  }
}
