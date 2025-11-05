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

# Example: Multi-tenant application that can be used by any Azure AD tenant
module "app_registrations" {
  source = "../../"

  applications = {
    multi_tenant_app = {
      display_name                   = "Multi-Tenant SaaS Application"
      description                    = "A SaaS application available to any Azure AD tenant"
      sign_in_audience               = "AzureADMultipleOrgs" # Allows any Azure AD tenant
      fallback_public_client_enabled = false
      tags                           = ["saas", "multi-tenant", "production"]

      web = {
        homepage_url = "https://mysaasapp.com"
        redirect_uris = [
          "https://mysaasapp.com/auth/callback",
          "https://mysaasapp.com/auth/signin-oidc"
        ]
        logout_url = "https://mysaasapp.com/auth/signout"
        implicit_grant = {
          access_token_issuance_enabled = false
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
            },
            {
              id   = "37f7f235-527c-4136-accd-4a02d197296e" # openid
              type = "Scope"
            },
            {
              id   = "64a6cdd6-aab1-4aaf-94b8-3cc8405e90d0" # email
              type = "Scope"
            },
            {
              id   = "14dad69e-099b-42c9-810b-d002981feec1" # profile
              type = "Scope"
            }
          ]
        }
      ]

      optional_claims = {
        access_token = [
          {
            name      = "email"
            essential = false
          }
        ]
        id_token = [
          {
            name      = "email"
            essential = false
          },
          {
            name      = "family_name"
            essential = false
          },
          {
            name      = "given_name"
            essential = false
          }
        ]
      }

      create_service_principal                        = true
      service_principal_app_role_assignment_required  = false
      service_principal_preferred_single_sign_on_mode = "oidc"
      service_principal_notification_email_addresses  = ["admin@mysaasapp.com"]
      service_principal_tags                          = ["saas", "multi-tenant"]
      service_principal_login_url                     = "https://mysaasapp.com"
    }

    multi_tenant_api = {
      display_name     = "Multi-Tenant API"
      description      = "API available to applications in any Azure AD tenant"
      sign_in_audience = "AzureADMultipleOrgs"
      identifier_uris  = ["api://multi-tenant-api"]
      tags             = ["api", "multi-tenant"]

      api = {
        requested_access_token_version = 2
        oauth2_permission_scopes = [
          {
            # IMPORTANT: Generate new unique UUIDs for production use
            # Example: uuidgen or New-Guid in PowerShell
            id                         = "d1e2f3a4-b5c6-7890-abcd-ef1234567890"
            admin_consent_description  = "Allows the application to access the multi-tenant API"
            admin_consent_display_name = "Access Multi-Tenant API"
            enabled                    = true
            type                       = "User"
            user_consent_description   = "Allows the application to access the API on your behalf"
            user_consent_display_name  = "Access API"
            value                      = "access_as_user"
          }
        ]
      }

      app_roles = [
        {
          # IMPORTANT: Generate new unique UUIDs for production use
          id                   = "e2f3a4b5-c6d7-8901-bcde-f12345678901"
          allowed_member_types = ["User"]
          description          = "Users with this role can administer the application"
          display_name         = "Administrator"
          enabled              = true
          value                = "Admin"
        },
        {
          # IMPORTANT: Generate new unique UUIDs for production use
          id                   = "f3a4b5c6-d7e8-9012-cdef-123456789012"
          allowed_member_types = ["User"]
          description          = "Regular users of the application"
          display_name         = "User"
          enabled              = true
          value                = "User"
        }
      ]

      create_service_principal = true
      service_principal_tags   = ["api", "multi-tenant"]
    }
  }
}

# Outputs
output "multi_tenant_app_details" {
  description = "Details of the multi-tenant application"
  value = {
    application_id = module.app_registrations.application_ids["multi_tenant_app"]
    object_id      = module.app_registrations.application_object_ids["multi_tenant_app"]
  }
}

output "multi_tenant_api_details" {
  description = "Details of the multi-tenant API"
  value = {
    application_id = module.app_registrations.application_ids["multi_tenant_api"]
    object_id      = module.app_registrations.application_object_ids["multi_tenant_api"]
  }
}

output "service_principals" {
  description = "Service principal details for all applications"
  value       = module.app_registrations.service_principals
}
