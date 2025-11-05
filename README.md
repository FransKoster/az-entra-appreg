# Azure Entra ID Application Registration Terraform Module

This Terraform module creates multiple Azure Entra ID Application Registrations and their associated Enterprise Applications (Service Principals).

## Features

- Create multiple Azure Entra ID Application Registrations
- Automatically create associated Service Principals (Enterprise Applications)
- Support for various application types:
  - Web Applications
  - Single Page Applications (SPA)
  - Public Client Applications
  - API Applications
- Configurable authentication and authorization settings
- Support for API permissions and app roles
- Optional claims configuration
- OAuth2 permission scopes
- Required resource access configuration

## Usage

### Basic Example

```hcl
module "app_registrations" {
  source = "github.com/FransKoster/az-entra-appreg"

  applications = {
    my_web_app = {
      display_name     = "My Web Application"
      description      = "A sample web application"
      sign_in_audience = "AzureADMyOrg"

      web = {
        homepage_url  = "https://myapp.example.com"
        redirect_uris = ["https://myapp.example.com/auth/callback"]
        implicit_grant = {
          access_token_issuance_enabled = true
          id_token_issuance_enabled     = true
        }
      }

      # Create service principal (Enterprise Application)
      create_service_principal = true
    }
  }
}
```

### Complete Example with Multiple Applications

```hcl
module "app_registrations" {
  source = "github.com/FransKoster/az-entra-appreg"

  applications = {
    web_app = {
      display_name     = "My Web Application"
      description      = "A web application with Microsoft Graph access"
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

      create_service_principal                       = true
      service_principal_app_role_assignment_required = false
      service_principal_tags                         = ["production"]
    }

    api_app = {
      display_name     = "My API Application"
      description      = "An API with custom scopes and roles"
      sign_in_audience = "AzureADMyOrg"
      identifier_uris  = ["api://myapi"]

      api = {
        requested_access_token_version = 2
        oauth2_permission_scopes = [
          {
            id                         = "00000000-0000-0000-0000-000000000001"
            admin_consent_description  = "Allow the application to access the API"
            admin_consent_display_name = "Access API"
            enabled                    = true
            type                       = "User"
            user_consent_description   = "Allow the application to access the API on your behalf"
            user_consent_display_name  = "Access API"
            value                      = "access_as_user"
          }
        ]
      }

      app_roles = [
        {
          id                   = "00000000-0000-0000-0000-000000000002"
          allowed_member_types = ["User", "Application"]
          description          = "Admins can manage all resources"
          display_name         = "Admin"
          enabled              = true
          value                = "Admin"
        }
      ]

      create_service_principal                       = true
      service_principal_app_role_assignment_required = true
    }

    spa_app = {
      display_name     = "My SPA Application"
      description      = "A single page application"
      sign_in_audience = "AzureADMyOrg"

      single_page_application = {
        redirect_uris = ["https://myspa.example.com"]
      }

      create_service_principal = true
    }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| applications | Map of application registrations to create | `map(object)` | `{}` | no |

### Application Object Structure

Each application in the `applications` map supports the following attributes:

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| display_name | The display name for the application | `string` | - | yes |
| description | Description of the application | `string` | `null` | no |
| owners | List of object IDs of principals that will be granted ownership | `list(string)` | `[]` | no |
| sign_in_audience | The Microsoft account types that are supported for the current application | `string` | `"AzureADMyOrg"` | no |
| prevent_duplicate_names | Prevent creation if another application exists with the same display name | `bool` | `false` | no |
| group_membership_claims | Configures the groups claim issued in a user or OAuth 2.0 access token | `list(string)` | `null` | no |
| identifier_uris | A list of user-defined URI(s) that uniquely identify an application within its Azure AD tenant | `list(string)` | `null` | no |
| fallback_public_client_enabled | Specifies whether the application is a public client | `bool` | `false` | no |
| tags | A set of tags to apply to the application | `list(string)` | `[]` | no |
| web | Web application configuration | `object` | `null` | no |
| single_page_application | Single page application configuration | `object` | `null` | no |
| public_client | Public client configuration | `object` | `null` | no |
| api | API configuration including OAuth2 permission scopes | `object` | `null` | no |
| app_roles | List of app roles for the application | `list(object)` | `null` | no |
| required_resource_access | List of resources the application requires access to | `list(object)` | `null` | no |
| optional_claims | Optional claims configuration | `object` | `null` | no |
| create_service_principal | Whether to create a service principal for this application | `bool` | `true` | no |
| service_principal_account_enabled | Whether the service principal account is enabled | `bool` | `true` | no |
| service_principal_app_role_assignment_required | Whether this service principal requires an app role assignment | `bool` | `false` | no |
| service_principal_description | Description of the service principal | `string` | `null` | no |
| service_principal_login_url | The URL where the service provider redirects the user to Azure AD to authenticate | `string` | `null` | no |
| service_principal_notes | Notes for the service principal | `string` | `null` | no |
| service_principal_notification_email_addresses | List of email addresses for notifications | `list(string)` | `null` | no |
| service_principal_owners | List of object IDs of principals that will be granted ownership | `list(string)` | `[]` | no |
| service_principal_preferred_single_sign_on_mode | The single sign-on mode configured for this application | `string` | `null` | no |
| service_principal_tags | A set of tags to apply to the service principal | `list(string)` | `null` | no |
| service_principal_use_existing | Use an existing service principal instead of creating a new one | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| applications | Map of created application registrations with their details |
| service_principals | Map of created service principals (enterprise applications) with their details |
| application_ids | Map of application keys to their application (client) IDs |
| application_object_ids | Map of application keys to their object IDs |
| service_principal_object_ids | Map of service principal keys to their object IDs |

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azuread | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| azuread | >= 3.0 |

## Resources

| Name | Type |
|------|------|
| azuread_application | resource |
| azuread_service_principal | resource |

## Examples

See the [examples](./examples) directory for more detailed examples:

- [Basic Example](./examples/basic) - Simple example with multiple application types

## Common Use Cases

### Web Application with Microsoft Graph Access

```hcl
applications = {
  web_app = {
    display_name = "My Web App"
    web = {
      redirect_uris = ["https://myapp.com/callback"]
    }
    required_resource_access = [
      {
        resource_app_id = "00000003-0000-0000-c000-000000000000"
        resource_access = [
          {
            id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
            type = "Scope"
          }
        ]
      }
    ]
    create_service_principal = true
  }
}
```

### API with Custom Scopes

```hcl
applications = {
  api = {
    display_name    = "My API"
    identifier_uris = ["api://myapi"]
    api = {
      oauth2_permission_scopes = [
        {
          id                         = "00000000-0000-0000-0000-000000000001"
          admin_consent_description  = "Access the API"
          admin_consent_display_name = "Access API"
          value                      = "access_as_user"
        }
      ]
    }
    create_service_principal = true
  }
}
```

### Application with App Roles

```hcl
applications = {
  app_with_roles = {
    display_name = "App with Roles"
    app_roles = [
      {
        id                   = "00000000-0000-0000-0000-000000000001"
        allowed_member_types = ["User"]
        description          = "Admins can manage everything"
        display_name         = "Admin"
        value                = "Admin"
      }
    ]
    create_service_principal = true
  }
}
```

## Notes

- The module uses the AzureAD Terraform provider to manage Azure Entra ID resources
- Application registrations and service principals are managed separately
- Set `create_service_principal = false` if you only want to create the application registration without the enterprise application
- Make sure you have the necessary permissions in Azure Entra ID to create applications and service principals
- **IMPORTANT**: UUIDs for app roles and OAuth2 permission scopes must be unique and should be generated before use
  - Linux/macOS: Use `uuidgen` command
  - Windows PowerShell: Use `New-Guid` cmdlet
  - Online: Use a UUID generator tool
  - Never use the placeholder UUIDs from examples in production

## License

MIT

## Authors

Maintained by Frans Koster
