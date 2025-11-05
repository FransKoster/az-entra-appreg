locals {
  # Flatten applications to create a list for service principals
  service_principals_to_create = {
    for key, app in var.applications :
    key => app if app.create_service_principal && !app.service_principal_use_existing
  }
}

# Create Application Registrations
resource "azuread_application" "this" {
  for_each = var.applications

  display_name                   = each.value.display_name
  description                    = each.value.description
  owners                         = each.value.owners
  sign_in_audience               = each.value.sign_in_audience
  prevent_duplicate_names        = each.value.prevent_duplicate_names
  group_membership_claims        = each.value.group_membership_claims
  identifier_uris                = each.value.identifier_uris
  fallback_public_client_enabled = each.value.fallback_public_client_enabled
  tags                           = each.value.tags

  dynamic "web" {
    for_each = each.value.web != null ? [each.value.web] : []
    content {
      homepage_url  = web.value.homepage_url
      logout_url    = web.value.logout_url
      redirect_uris = web.value.redirect_uris

      dynamic "implicit_grant" {
        for_each = web.value.implicit_grant != null ? [web.value.implicit_grant] : []
        content {
          access_token_issuance_enabled = implicit_grant.value.access_token_issuance_enabled
          id_token_issuance_enabled     = implicit_grant.value.id_token_issuance_enabled
        }
      }
    }
  }

  dynamic "single_page_application" {
    for_each = each.value.single_page_application != null ? [each.value.single_page_application] : []
    content {
      redirect_uris = single_page_application.value.redirect_uris
    }
  }

  dynamic "public_client" {
    for_each = each.value.public_client != null ? [each.value.public_client] : []
    content {
      redirect_uris = public_client.value.redirect_uris
    }
  }

  dynamic "api" {
    for_each = each.value.api != null ? [each.value.api] : []
    content {
      mapped_claims_enabled          = api.value.mapped_claims_enabled
      requested_access_token_version = api.value.requested_access_token_version
      known_client_applications      = api.value.known_client_applications

      dynamic "oauth2_permission_scope" {
        for_each = api.value.oauth2_permission_scopes != null ? api.value.oauth2_permission_scopes : []
        content {
          id                         = oauth2_permission_scope.value.id
          admin_consent_description  = oauth2_permission_scope.value.admin_consent_description
          admin_consent_display_name = oauth2_permission_scope.value.admin_consent_display_name
          enabled                    = oauth2_permission_scope.value.enabled
          type                       = oauth2_permission_scope.value.type
          user_consent_description   = oauth2_permission_scope.value.user_consent_description
          user_consent_display_name  = oauth2_permission_scope.value.user_consent_display_name
          value                      = oauth2_permission_scope.value.value
        }
      }
    }
  }

  dynamic "app_role" {
    for_each = each.value.app_roles != null ? each.value.app_roles : []
    content {
      id                   = app_role.value.id
      allowed_member_types = app_role.value.allowed_member_types
      description          = app_role.value.description
      display_name         = app_role.value.display_name
      enabled              = app_role.value.enabled
      value                = app_role.value.value
    }
  }

  dynamic "required_resource_access" {
    for_each = each.value.required_resource_access != null ? each.value.required_resource_access : []
    content {
      resource_app_id = required_resource_access.value.resource_app_id

      dynamic "resource_access" {
        for_each = required_resource_access.value.resource_access
        content {
          id   = resource_access.value.id
          type = resource_access.value.type
        }
      }
    }
  }

  dynamic "optional_claims" {
    for_each = each.value.optional_claims != null ? [each.value.optional_claims] : []
    content {
      dynamic "access_token" {
        for_each = optional_claims.value.access_token != null ? optional_claims.value.access_token : []
        content {
          name                  = access_token.value.name
          source                = access_token.value.source
          essential             = access_token.value.essential
          additional_properties = access_token.value.additional_properties
        }
      }

      dynamic "id_token" {
        for_each = optional_claims.value.id_token != null ? optional_claims.value.id_token : []
        content {
          name                  = id_token.value.name
          source                = id_token.value.source
          essential             = id_token.value.essential
          additional_properties = id_token.value.additional_properties
        }
      }

      dynamic "saml2_token" {
        for_each = optional_claims.value.saml2_token != null ? optional_claims.value.saml2_token : []
        content {
          name                  = saml2_token.value.name
          source                = saml2_token.value.source
          essential             = saml2_token.value.essential
          additional_properties = saml2_token.value.additional_properties
        }
      }
    }
  }
}

# Create Service Principals (Enterprise Applications)
resource "azuread_service_principal" "this" {
  for_each = local.service_principals_to_create

  client_id                     = azuread_application.this[each.key].client_id
  account_enabled               = each.value.service_principal_account_enabled
  app_role_assignment_required  = each.value.service_principal_app_role_assignment_required
  description                   = each.value.service_principal_description
  login_url                     = each.value.service_principal_login_url
  notes                         = each.value.service_principal_notes
  notification_email_addresses  = each.value.service_principal_notification_email_addresses
  owners                        = each.value.service_principal_owners
  preferred_single_sign_on_mode = each.value.service_principal_preferred_single_sign_on_mode
  tags                          = each.value.service_principal_tags
}
