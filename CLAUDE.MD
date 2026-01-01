# CLAUDE.MD - Homelab Infrastructure Project

This document provides context for Claude Code to effectively work with this repository.

## Project Overview

This is a homelab infrastructure-as-code repository that manages DNS records in Cloudflare using OpenTofu (Terraform fork). The infrastructure is deployed automatically via GitHub Actions with a workflow that plans on PRs and applies on merge to main.

## Repository Structure

```
homelab/
├── terraform/                    # Root terraform directory
│   ├── dns/
│   │   └── cloudflare/           # Cloudflare DNS module
│   │       ├── cloudflare.tf     # Main DNS records configuration
│   │       ├── variables.tf      # Module input variables (zone_id)
│   │       ├── versions.tf       # Module provider requirements
│   │       └── records-from-csv.tf # CSV processing (not implemented - empty file)
│   ├── backend.tf                # Terraform Cloud backend configuration
│   ├── providers.tf              # Cloudflare provider config + requirements
│   ├── variables.tf              # Root variable declarations
│   ├── terraform.tfvars          # Variable values (Zone ID)
│   ├── terraform.tfvars.example  # Example template
│   ├── main.tf                   # Root module - imports child modules
│   ├── outputs.tf                # Outputs (empty placeholder)
│   └── versions.tf               # Version constraints (empty placeholder)
├── .github/
│   └── workflows/
│       └── opentofu.yml          # CI/CD workflow
├── .gitignore                    # Git exclusion rules
├── LICENSE                       # MIT License
├── .env                          # Local environment variables (TF_VAR_cloudflare_api_token)
├── README.md                     # User-facing documentation
└── CLAUDE.MD                     # This file - Claude Code context
```

## Current State

- **DNS Records**: Currently one test record configured (`tf-test.pressler.cloud` → `1.2.3.4`)
- **Module Structure**: Using modular architecture - root `main.tf` imports `dns/cloudflare` child module
- **Empty Files**: `versions.tf`, `outputs.tf`, `records-from-csv.tf` are placeholder files with no content
- **CSV Management**: Not yet implemented
- **Domain**: Managing `pressler.cloud` (Zone ID: `432d2dcc3c1531f7ad9c3cfeeedb7c83`)

## Technology Stack

- **IaC Tool**: OpenTofu v1.11.0 (Terraform fork)
- **Provider**: Cloudflare v5.15.0
- **State Backend**: Terraform Cloud (organization: "pressler-cloud", workspace: "homelab-dns-cloudflare")
- **CI/CD**: GitHub Actions
- **Version Control**: Git

## Key Files and Their Purpose

### Infrastructure Files

#### Root Module
- [terraform/main.tf](terraform/main.tf): Root module that imports child modules (dns/cloudflare)
- [terraform/variables.tf](terraform/variables.tf): Root variable declarations (api_token, zone_id)
- [terraform/backend.tf](terraform/backend.tf): Terraform Cloud backend configuration
- [terraform/providers.tf](terraform/providers.tf): Provider configuration and requirements
- [terraform/terraform.tfvars](terraform/terraform.tfvars): Variable values (Zone ID)

#### dns/cloudflare Module
- [terraform/dns/cloudflare/cloudflare.tf](terraform/dns/cloudflare/cloudflare.tf): DNS record resources
- [terraform/dns/cloudflare/variables.tf](terraform/dns/cloudflare/variables.tf): Module input variables (receives zone_id from root)
- [terraform/dns/cloudflare/versions.tf](terraform/dns/cloudflare/versions.tf): Module provider requirements
- [terraform/dns/cloudflare/records-from-csv.tf](terraform/dns/cloudflare/records-from-csv.tf): Logic for processing CSV-based DNS records (not implemented)

### CI/CD

- [.github/workflows/opentofu.yml](.github/workflows/opentofu.yml): GitHub Actions workflow that:
  - Runs `tofu fmt -check` to ensure code formatting
  - Initializes OpenTofu with Terraform Cloud backend
  - Validates configuration
  - Plans changes on all PRs and pushes
  - Auto-applies on merge to main branch
  - Working directory: `terraform/`

## Important Conventions

### DNS Records

- Records are defined in [terraform/dns/cloudflare/cloudflare.tf](terraform/dns/cloudflare/cloudflare.tf)
- Future plan: Simple records (A, AAAA, CNAME, MX) from CSV (not yet implemented)
- Complex records (TXT with special characters, CAA) should be added directly to `cloudflare.tf`
- Always include comments in format: `owner=<name> | source=<source> | comment=<description>`
- Use `proxied = "false"` for non-proxied records, `"true"` for proxied (A/AAAA/CNAME only)
- TTL of 1 means "auto" in Cloudflare
- Use `local.zone_id` to reference the zone ID (defined in locals block)

### Git Workflow

- **Main branch**: `main` - protected, requires PRs
- **Feature branches**: Should start with `claude/` for Claude Code work
- **Branch naming**: Use descriptive names like `claude/add-dns-record-XXXXX` (ends with session ID)
- **Current working branch**: `claude/update-claude-md-K7VET`

### Code Style

- Run `tofu fmt` before committing to ensure proper formatting
- Validate with `tofu validate` before pushing
- Always test with `tofu plan` locally when possible

## Secrets and Environment Variables

The following secrets are configured in GitHub Actions:

- `CLOUDFLARE_API_TOKEN`: Cloudflare API token with DNS edit permissions
- `TF_API_TOKEN`: Terraform Cloud API token for state management

These are injected as environment variables:
- `TF_VAR_cloudflare_api_token`: Set from `CLOUDFLARE_API_TOKEN` secret

Variables defined in [terraform/variables.tf](terraform/variables.tf):
- `cloudflare_api_token`: Cloudflare authentication (sensitive)
- `cloudflare_zone_id_pressler_cloud`: The Cloudflare zone ID for pressler.cloud domain

Local development uses [.env](.env) file with:
- `TF_VAR_cloudflare_api_token`: Cloudflare API token

## Common Development Tasks

### Adding a New DNS Record

1. Edit [terraform/dns/cloudflare/cloudflare.tf](terraform/dns/cloudflare/cloudflare.tf)
2. Add new resource following the pattern:
   ```hcl
   resource "cloudflare_dns_record" "example" {
     zone_id = local.zone_id
     name    = "subdomain"
     type    = "A"
     content = "1.2.3.4"
     ttl     = 1
     proxied = "false"
     comment = "owner=<name> | source=manual | comment=Description"
   }
   ```
3. Run `tofu fmt` to format the code
4. Run `tofu validate` to check syntax
5. Run `tofu plan` to preview changes (requires authentication)

### Testing Changes Locally

```bash
cd terraform
tofu login  # Authenticate with Terraform Cloud (first time only)
tofu init   # Initialize backend and providers
tofu fmt    # Format code
tofu validate  # Validate configuration
tofu plan   # Preview changes
```

### Deployment Process

1. Create a feature branch (e.g., `claude/add-new-record-XXXXX`)
2. Make changes to OpenTofu files
3. Commit changes with descriptive messages
4. Push to origin: `git push -u origin <branch-name>`
5. Create a Pull Request
6. Review the plan output in GitHub Actions
7. Merge PR to trigger automatic apply

## Important Notes for Claude Code

### When Making Changes

- **Always read files before editing**: Use Read tool before Edit tool
- **Format before committing**: Run `tofu fmt` on modified `.tf` files
- **Test locally when possible**: Run `tofu plan` to validate changes
- **Use existing patterns**: Follow the comment format and structure of existing resources
- **Reference local.zone_id**: Don't hardcode zone IDs, use the local variable
- **Avoid over-engineering**: Keep changes simple and focused on the request
- **Don't add unnecessary features**: Only implement what's requested
- **Module structure**: DNS records go in `dns/cloudflare/cloudflare.tf`, not root module
- **Provider config**: Only configure providers in root `providers.tf`, modules only declare requirements in `versions.tf`

### Git Operations

- **Branch naming**: Must start with `claude/` and end with session ID for successful push
- **Push command**: Always use `git push -u origin <branch-name>`
- **Retry on network errors**: Up to 4 retries with exponential backoff (2s, 4s, 8s, 16s)
- **Never push to main directly**: Always use PRs

### Security Considerations

- Never commit secrets or sensitive values
- Don't modify `.gitignore` to expose sensitive files
- Keep API tokens in GitHub secrets and `.env` file only
- Review all changes before pushing
- Validate that no sensitive data is in commit history
- The `.env` file is properly excluded in `.gitignore`

### OpenTofu/Terraform Specifics

- **Provider version**: Locked to Cloudflare v5.15.0 - don't change without testing
- **OpenTofu version**: Using 1.11.0 - specified in GitHub Actions
- **State management**: Handled by Terraform Cloud - never commit state files
- **Backend**: Configured in [terraform/backend.tf](terraform/backend.tf) - don't modify without coordination
- **Working directory**: Root is `terraform/` - not `dns/cloudflare/terraform/`
- **Module architecture**: Root module in `terraform/main.tf` imports child modules
- **Provider inheritance**: Child modules inherit provider config from root - only declare `required_providers` in module `versions.tf`
- **Variable passing**: Root variables passed to modules via module block parameters in `main.tf`

## Testing Strategy

- **Automated**: GitHub Actions runs fmt check, init, validate, and plan on all PRs
- **Manual**: Local testing with `tofu plan` before pushing
- **Deployment verification**: Check Cloudflare dashboard after apply to confirm changes

## Troubleshooting

### Common Issues

1. **Format check fails**: Run `tofu fmt` locally before committing
2. **Authentication errors**: Check that secrets are properly configured in GitHub or `.env` file locally
3. **Plan fails**: Validate configuration locally with `tofu validate`
4. **State lock errors**: Check Terraform Cloud workspace for stuck locks
5. **Push fails with 403**: Ensure branch name starts with `claude/` and ends with session ID
6. **Provider not found (hashicorp/cloudflare)**: Child modules need `versions.tf` with `required_providers` block pointing to `cloudflare/cloudflare`
7. **Resource recreating after module refactor**: Use `terraform state mv <old_address> module.<module_name>.<resource>` to move state

## Future Enhancements

Planned improvements include:
- CSV-based record management implementation
- Support for multiple domains/zones
- DNS record validation
- Pre-commit hooks for validation
- Bulk record management scripts
- Monitoring/alerting for DNS changes

## Resources

- [OpenTofu Documentation](https://opentofu.org/docs/)
- [Cloudflare Provider Documentation](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs)
- [Terraform Cloud Documentation](https://developer.hashicorp.com/terraform/cloud-docs)
- Repository README: See [README.md](README.md) for detailed setup instructions (if exists)
