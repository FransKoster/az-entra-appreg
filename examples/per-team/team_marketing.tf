locals {
  team_marketing_apps = {
    marketing_spa = {
      display_name             = "Marketing - SPA"
      description              = "Single page app for marketing site"
      sign_in_audience         = "AzureADMyOrg"
      create_service_principal = false
      tags                     = ["team:marketing"]
      single_page_application = {
        redirect_uris = ["https://marketing.example.local/auth/callback"]
      }
    }
  }
}
