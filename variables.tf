variable "applications" {
  description = "Map of application registrations to create"
  type = map(object({
    display_name                   = string
    description                    = optional(string)
    owners                         = optional(list(string), [])
    sign_in_audience               = optional(string, "AzureADMyOrg")
    prevent_duplicate_names        = optional(bool, false)
    group_membership_claims        = optional(list(string))
    identifier_uris                = optional(list(string))
    fallback_public_client_enabled = optional(bool, false)

    tags = optional(list(string), [])

    web = optional(object({
      homepage_url  = optional(string)
      logout_url    = optional(string)
      redirect_uris = optional(list(string))
      implicit_grant = optional(object({
        access_token_issuance_enabled = optional(bool, false)
        id_token_issuance_enabled     = optional(bool, false)
      }))
    }))

    single_page_application = optional(object({
      redirect_uris = optional(list(string))
    }))

    public_client = optional(object({
      redirect_uris = optional(list(string))
    }))

    api = optional(object({
      mapped_claims_enabled          = optional(bool, false)
      requested_access_token_version = optional(number, 2)
      known_client_applications      = optional(list(string))
      oauth2_permission_scopes = optional(list(object({
        id                         = string
        admin_consent_description  = string
        admin_consent_display_name = string
        enabled                    = optional(bool, true)
        type                       = optional(string, "User")
        user_consent_description   = optional(string)
        user_consent_display_name  = optional(string)
        value                      = string
      })))
    }))

    app_roles = optional(list(object({
      id                   = string
      allowed_member_types = list(string)
      description          = string
      display_name         = string
      enabled              = optional(bool, true)
      value                = string
    })))

    required_resource_access = optional(list(object({
      resource_app_id = string
      resource_access = list(object({
        id   = string
        type = string
      }))
    })))

    optional_claims = optional(object({
      access_token = optional(list(object({
        name                  = string
        source                = optional(string)
        essential             = optional(bool, false)
        additional_properties = optional(list(string))
      })))
      id_token = optional(list(object({
        name                  = string
        source                = optional(string)
        essential             = optional(bool, false)
        additional_properties = optional(list(string))
      })))
      saml2_token = optional(list(object({
        name                  = string
        source                = optional(string)
        essential             = optional(bool, false)
        additional_properties = optional(list(string))
      })))
    }))

    create_service_principal                        = optional(bool, true)
    service_principal_account_enabled               = optional(bool, true)
    service_principal_app_role_assignment_required  = optional(bool, false)
    service_principal_description                   = optional(string)
    service_principal_login_url                     = optional(string)
    service_principal_notes                         = optional(string)
    service_principal_notification_email_addresses  = optional(list(string))
    service_principal_owners                        = optional(list(string), [])
    service_principal_preferred_single_sign_on_mode = optional(string)
    service_principal_tags                          = optional(list(string))
    service_principal_use_existing                  = optional(bool, false)
  }))
  default = {}
}
