# Basic Example

This example demonstrates the basic usage of the Azure Entra ID Application Registration module with different types of applications:

1. **Web Application** - A standard web application with OAuth2 implicit grant
2. **API Application** - An API with custom OAuth2 permission scopes and app roles
3. **SPA Application** - A single page application

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Prerequisites

- Azure CLI or appropriate authentication configured
- Appropriate permissions to create applications in Azure Entra ID

## What This Example Creates

- Three application registrations
- Three service principals (enterprise applications)
- Configured redirect URIs and permissions
- OAuth2 permission scopes for the API
- App roles for authorization

## Outputs

- `application_ids` - Map of application IDs
- `applications` - Full details of all applications
- `service_principals` - Details of all service principals
