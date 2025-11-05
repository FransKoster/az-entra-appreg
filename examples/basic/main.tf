terraform {
  required_version = ">= 1.0"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 3.0"
    }
  }
}

provider "azuread" {
  # Configuration options
}

# Example: Create multiple Azure Entra ID Application Registrations
module "app_registrations" {
  source = "../../"

  applications = {
    app1 = {
      display_name     = "My Web Application"
      description      = "A sample web application"
      sign_in_audience = "AzureADMyOrg"
      tags             = ["webapp", "production"]

      web = {
        homepage_url  = "https://myapp.example.com"
        redirect_uris = ["https://myapp.example.com/auth/callback"]
        implicit_grant = {
          access_token_issuance_enabled = true
          id_token_issuance_enabled     = true
        }
      }

      required_resource_access = [
        {
          resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph
          resource_access = [
            {
              id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
              type = "Scope"
            }
          ]
        }
      ]

      # Create service principal (Enterprise Application)
      create_service_principal                       = true
      service_principal_app_role_assignment_required = false
      service_principal_tags                         = ["production"]
    }

    app2 = {
      display_name     = "My API Application"
      description      = "A sample API application"
      sign_in_audience = "AzureADMyOrg"
      identifier_uris  = ["api://myapi"]
      tags             = ["api", "production"]

      api = {
        requested_access_token_version = 2
        oauth2_permission_scopes = [
          {
            # IMPORTANT: Generate a new unique UUID for production use
            # Example: uuidgen or New-Guid in PowerShell
            id                         = "00000000-0000-0000-0000-000000000001"
            admin_consent_description  = "Allow the application to access the API on behalf of the signed-in user."
            admin_consent_display_name = "Access API"
            enabled                    = true
            type                       = "User"
            user_consent_description   = "Allow the application to access the API on your behalf."
            user_consent_display_name  = "Access API"
            value                      = "access_as_user"
          }
        ]
      }

      app_roles = [
        {
          # IMPORTANT: Generate a new unique UUID for production use
          # Example: uuidgen or New-Guid in PowerShell
          id                   = "00000000-0000-0000-0000-000000000002"
          allowed_member_types = ["User", "Application"]
          description          = "Admins can manage all resources"
          display_name         = "Admin"
          enabled              = true
          value                = "Admin"
        }
      ]

      # Create service principal (Enterprise Application)
      create_service_principal                       = true
      service_principal_app_role_assignment_required = true
      service_principal_tags                         = ["api", "production"]
    }

    spa_app = {
      display_name     = "My SPA Application"
      description      = "A single page application"
      sign_in_audience = "AzureADMyOrg"
      tags             = ["spa", "production"]

      single_page_application = {
        redirect_uris = ["https://myspa.example.com"]
      }

      required_resource_access = [
        {
          resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph
          resource_access = [
            {
              id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
              type = "Scope"
            }
          ]
        }
      ]

      # Create service principal (Enterprise Application)
      create_service_principal = true
    }
  }
}

# Outputs
output "application_ids" {
  description = "Application IDs of created apps"
  value       = module.app_registrations.application_ids
}

output "applications" {
  description = "Full application details"
  value       = module.app_registrations.applications
}

output "service_principals" {
  description = "Service principal details"
  value       = module.app_registrations.service_principals
}
