terraform {
  required_version = ">= 1.0"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.0"
    }
  }
}

provider "azuread" {
  # Configuration options
}

# Example: API application with client application accessing it
module "app_registrations" {
  source = "../../"

  applications = {
    # Backend API Application
    api = {
      display_name     = "My Backend API"
      description      = "Backend API with custom scopes"
      sign_in_audience = "AzureADMyOrg"
      identifier_uris  = ["api://backend-api"]
      tags             = ["api", "backend"]

      api = {
        requested_access_token_version = 2
        oauth2_permission_scopes = [
          {
            id                         = "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
            admin_consent_description  = "Allows the application to read data from the API"
            admin_consent_display_name = "Read API Data"
            enabled                    = true
            type                       = "User"
            user_consent_description   = "Allows the application to read data from the API on your behalf"
            user_consent_display_name  = "Read API Data"
            value                      = "API.Read"
          },
          {
            id                         = "b2c3d4e5-f6a7-8901-bcde-f12345678901"
            admin_consent_description  = "Allows the application to write data to the API"
            admin_consent_display_name = "Write API Data"
            enabled                    = true
            type                       = "User"
            user_consent_description   = "Allows the application to write data to the API on your behalf"
            user_consent_display_name  = "Write API Data"
            value                      = "API.Write"
          }
        ]
      }

      app_roles = [
        {
          id                   = "c3d4e5f6-a7b8-9012-cdef-123456789012"
          allowed_member_types = ["Application"]
          description          = "Allows daemon apps to access the API"
          display_name         = "Daemon Access"
          enabled              = true
          value                = "Daemon.Access"
        }
      ]

      create_service_principal                       = true
      service_principal_app_role_assignment_required = false
      service_principal_tags                         = ["api"]
    }

    # Frontend Client Application
    client = {
      display_name     = "My Frontend Client"
      description      = "Frontend client application"
      sign_in_audience = "AzureADMyOrg"
      tags             = ["frontend", "client"]

      single_page_application = {
        redirect_uris = [
          "https://frontend.example.com",
          "http://localhost:3000"
        ]
      }

      required_resource_access = [
        {
          # Microsoft Graph
          resource_app_id = "00000003-0000-0000-c000-000000000000"
          resource_access = [
            {
              id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
              type = "Scope"
            }
          ]
        },
        {
          # Backend API (references the API application created above)
          # Note: In practice, you would use the actual application ID of your API
          resource_app_id = "api://backend-api"
          resource_access = [
            {
              id   = "a1b2c3d4-e5f6-7890-abcd-ef1234567890" # API.Read
              type = "Scope"
            },
            {
              id   = "b2c3d4e5-f6a7-8901-bcde-f12345678901" # API.Write
              type = "Scope"
            }
          ]
        }
      ]

      create_service_principal = true
      service_principal_tags   = ["frontend"]
    }

    # Daemon/Service Application
    daemon = {
      display_name     = "My Background Service"
      description      = "Background service with daemon permissions"
      sign_in_audience = "AzureADMyOrg"
      tags             = ["daemon", "service"]

      required_resource_access = [
        {
          # Backend API (application permission)
          resource_app_id = "api://backend-api"
          resource_access = [
            {
              id   = "c3d4e5f6-a7b8-9012-cdef-123456789012" # Daemon.Access
              type = "Role"                                 # Application permission
            }
          ]
        }
      ]

      create_service_principal                       = true
      service_principal_app_role_assignment_required = false
      service_principal_tags                         = ["daemon"]
    }
  }
}

# Outputs
output "api_application_id" {
  description = "Application ID of the API"
  value       = module.app_registrations.application_ids["api"]
}

output "client_application_id" {
  description = "Application ID of the client"
  value       = module.app_registrations.application_ids["client"]
}

output "daemon_application_id" {
  description = "Application ID of the daemon"
  value       = module.app_registrations.application_ids["daemon"]
}

output "all_applications" {
  description = "All application details"
  value       = module.app_registrations.applications
}
