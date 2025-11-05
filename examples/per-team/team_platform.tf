locals {
  team_platform_apps = {
    platform_api = {
      display_name             = "Platform - API"
      description              = "Platform API registration"
      sign_in_audience         = "AzureADMyOrg"
      create_service_principal = true
      tags                     = ["team:platform"]
      api = {
        requested_access_token_version = 2
        oauth2_permission_scopes = [
          {
            id                         = "11111111-1111-1111-1111-111111111111"
            admin_consent_description  = "Access Platform API"
            admin_consent_display_name = "Platform API"
            value                      = "access_as_user"
          }
        ]
      }
    }
  }
}
