# TFE Teams Terraform module

Terraform module to manage Terraform Enterprise teams.

## Usage

[Generating user token](https://app.terraform.io/app/settings/tokens)

```terraform
module "tfe-org-teams" {
  source = "tfelab/teams/tfe"

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
    },
    {
      name                          = "auditors"
      allow_member_token_management = false
      organization                  = "tfelab"
      organization_access = {
        read_projects   = true
        read_workspaces = true
      }
    },
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
        email = "admin@domain.com"
        teams = [
          "admins"
        ]
      },
      {
        email = "auditor@domain.com"
        teams = [
          "auditors"
        ]
      },
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
```

## Examples

- [Organization admins](https://github.com/tfelab/terraform-tfe-teams/tree/main/examples/org-admins)
- [Organization auditors](https://github.com/tfelab/terraform-tfe-teams/tree/main/examples/org-auditors)
- [Project](https://github.com/tfelab/terraform-tfe-teams/tree/main/examples/project)
- [Workspace](https://github.com/tfelab/terraform-tfe-teams/tree/main/examples/workspace)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 0.12 |
| <a name="requirement_tfe"></a> [tfe](#requirement_tfe) | >= 0.58.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tfe"></a> [tfe](#provider_tfe) | >= 0.58.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tfe_team.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/team) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tfe_token"></a> [tfe_token](#input_tfe_token) | The token use in connecting to TFE | `string` | `null` | yes |
| <a name="input_org_teams"></a> [org_teams](#input_org_teams) | List of organization teams and their configuration | `list` | [] | no |
| <a name="input_org_teams_member"></a> [org_teams_member](#input_org_teams_member) | List of organization team members and with their configuration | `list` | [] | no |
| <a name="input_project_teams_access"></a> [project_teams_access](#input_project_teams_access) | List of project teams access and their configuration | `list` | [] | no |
| <a name="input_workspace_teams_access"></a> [workspace_teams_access](#input_workspace_teams_access) | List of workspace teams access and their configuration | `list` | [] | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tfe_team_id"></a> [tfe_team_id](#output_tfe_team_id) | The id's of the TFE teams |
| <a name="output_tfe_team_name"></a> [tfe_team_name](#output_tfe_team_name) | The names of the TFE teams |

## Authors

Module is maintained by [John Ajera](https://github.com/jajera).

## License

MIT Licensed. See [LICENSE](https://github.com/tfelab/terraform-tfe-teams/tree/main/LICENSE) for full details.
