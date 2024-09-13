output "tfe_team_id" {
  value       = [for team in tfe_team.this : team.id]
  description = "The names of the TFE teams id"
}

output "tfe_team_name" {
  value       = [for team in tfe_team.this : team.name]
  description = "The names of the TFE teams names"
}
