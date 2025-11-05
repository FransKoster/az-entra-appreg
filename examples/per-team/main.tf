locals {
  # Merge per-team application maps defined in other files in this directory.
  # Add more `local.team_x_apps` blocks in additional files to scale.
  all_applications = merge(
    local.team_ops_apps,
    local.team_platform_apps,
    local.team_marketing_apps,
  )
}

module "app_registrations" {
  source       = "../../"
  applications = local.all_applications
}
