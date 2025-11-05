locals {
  team_ops_apps = {
    ops_health_probe = {
      display_name             = "Ops - Health Probe"
      description              = "Health probe app for ops team"
      sign_in_audience         = "AzureADMyOrg"
      create_service_principal = true
      tags                     = ["team:ops"]
      web = {
        homepage_url  = "https://ops.example.local/"
        redirect_uris = ["https://ops.example.local/.auth/login/aad/callback"]
      }
    }
  }
}
