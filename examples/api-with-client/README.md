# API with Client Example

This example demonstrates a common scenario where you have:

1. **Backend API** - An API application that exposes OAuth2 scopes and app roles
2. **Frontend Client** - A SPA that consumes the backend API
3. **Daemon Service** - A background service that accesses the API using application permissions

## Scenario

This setup is typical for modern applications where:
- The frontend SPA uses delegated permissions (on behalf of a user)
- The daemon service uses application permissions (without a user context)
- The API defines both user-delegated scopes and application roles

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

- One API application with OAuth2 permission scopes and app roles
- One client application (SPA) that requests delegated permissions to the API
- One daemon application that requests application permissions to the API
- Three service principals (enterprise applications)

## Important Notes

- After applying, you'll need to grant admin consent for the API permissions in the Azure Portal
- The daemon application uses application permissions (Role) which require admin consent
- The client application uses delegated permissions (Scope) which may require admin or user consent

## Outputs

- `api_application_id` - Application ID of the backend API
- `client_application_id` - Application ID of the frontend client
- `daemon_application_id` - Application ID of the daemon service
- `all_applications` - Full details of all applications
