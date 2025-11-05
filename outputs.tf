output "applications" {
  description = "Map of created application registrations with their details"
  value = {
    for key, app in azuread_application.this : key => {
      object_id             = app.object_id
      application_id        = app.application_id
      client_id             = app.client_id
      display_name          = app.display_name
      identifier_uris       = app.identifier_uris
      publisher_domain      = app.publisher_domain
      disabled_by_microsoft = app.disabled_by_microsoft
      logo_url              = app.logo_url
      marketing_url         = app.marketing_url
      notes                 = app.notes
      privacy_statement_url = app.privacy_statement_url
      support_url           = app.support_url
      terms_of_service_url  = app.terms_of_service_url
    }
  }
}

output "service_principals" {
  description = "Map of created service principals (enterprise applications) with their details"
  value = {
    for key, sp in azuread_service_principal.this : key => {
      object_id                    = sp.object_id
      application_id               = sp.application_id
      client_id                    = sp.client_id
      display_name                 = sp.display_name
      application_tenant_id        = sp.application_tenant_id
      app_role_assignment_required = sp.app_role_assignment_required
      homepage_url                 = sp.homepage_url
      login_url                    = sp.login_url
      logout_url                   = sp.logout_url
      redirect_uris                = sp.redirect_uris
      saml_metadata_url            = sp.saml_metadata_url
      service_principal_names      = sp.service_principal_names
      sign_in_audience             = sp.sign_in_audience
      type                         = sp.type
    }
  }
}

output "application_ids" {
  description = "Map of application keys to their application (client) IDs"
  value = {
    for key, app in azuread_application.this : key => app.application_id
  }
}

output "application_object_ids" {
  description = "Map of application keys to their object IDs"
  value = {
    for key, app in azuread_application.this : key => app.object_id
  }
}

output "service_principal_object_ids" {
  description = "Map of service principal keys to their object IDs"
  value = {
    for key, sp in azuread_service_principal.this : key => sp.object_id
  }
}
