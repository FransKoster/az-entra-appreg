# Per-team example

This example demonstrates the "per-team" pattern for managing many application registrations.

Structure:

- `team_*.tf` - each file defines a `local.team_<name>_apps` map with application definitions.
- `main.tf` - merges the per-team maps into `local.all_applications` and calls the module.

Usage:

1. Add or edit team files to include `local.team_X_apps` maps.
2. Run `terraform init` and `terraform plan` from this examples directory (or adjust the module source path as needed).

Notes:

- Keep sensitive data out of these files; use variables/secret managers for secrets.
- Use one file per team to reduce PR conflicts and keep ownership clear.
