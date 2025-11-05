# Multi-Tenant Example

This example demonstrates how to create multi-tenant applications that can be used by any Azure AD tenant. This is common for SaaS applications.

## Scenario

This setup creates:

1. **Multi-Tenant SaaS Application** - A web application with `AzureADMultipleOrgs` sign-in audience
2. **Multi-Tenant API** - An API that can be consumed by applications in any Azure AD tenant

## Key Features

- Applications are available to any Azure AD organization
- Optional claims are configured for additional user information
- OIDC single sign-on is configured
- App roles are defined for authorization across tenants

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Prerequisites

- Azure CLI or appropriate authentication configured
- Appropriate permissions to create applications in Azure Entra ID
- Understanding of multi-tenant application concepts in Azure AD

## What This Example Creates

- One multi-tenant web application with OIDC configuration
- One multi-tenant API with OAuth2 scopes and app roles
- Two service principals in your tenant (enterprise applications)

## Important Notes

- Multi-tenant applications require admin consent in each tenant where they are used
- Users from any Azure AD tenant can sign in to these applications
- You'll need to provide a verification domain for production multi-tenant apps
- Consider implementing proper tenant isolation in your application code

## Post-Deployment Steps

1. Grant admin consent for Microsoft Graph permissions in your tenant
2. Configure publisher domain verification for production use
3. Implement proper authorization logic in your application code
4. Test the application with users from different tenants

## Outputs

- `multi_tenant_app_details` - Details of the multi-tenant application
- `multi_tenant_api_details` - Details of the multi-tenant API
- `service_principals` - Service principal details for all applications
