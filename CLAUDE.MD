# CLAUDE.MD - Homelab Infrastructure Project

This document provides context for Claude Code to effectively work with this repository.

## Project Overview

This is a homelab infrastructure-as-code repository that manages DNS records in Cloudflare using OpenTofu (Terraform fork). The infrastructure is deployed automatically via GitHub Actions with a workflow that plans on PRs and applies on merge to main.

## Repository Structure

```
homelab/
├── dns/
│   └── cloudflare/
│       ├── records.csv              # DNS records definition (future use)
│       └── terraform/
│           ├── main.tf              # Main OpenTofu configuration with DNS records
│           ├── variables.tf         # Variable definitions
│           ├── backend.tf           # Terraform Cloud backend configuration
│           └── records-from-csv.tf  # CSV-based record processing
├── .github/
│   └── workflows/
│       └── opentofu.yml             # CI/CD workflow for OpenTofu
├── README.md                         # User-facing documentation
└── CLAUDE.MD                        # This file - Claude Code context
```

## Technology Stack

- **IaC Tool**: OpenTofu v1.11.0 (Terraform fork)
- **Provider**: Cloudflare v5.15.0
- **State Backend**: Terraform Cloud
- **CI/CD**: GitHub Actions
- **Version Control**: Git

## Key Files and Their Purpose

### Infrastructure Files

- `dns/cloudflare/terraform/main.tf`: Main OpenTofu configuration containing DNS record resources
- `dns/cloudflare/terraform/variables.tf`: Variable declarations for the Cloudflare provider
- `dns/cloudflare/terraform/backend.tf`: Terraform Cloud backend configuration
- `dns/cloudflare/terraform/records-from-csv.tf`: Logic for processing CSV-based DNS records

### CI/CD

- `.github/workflows/opentofu.yml`: GitHub Actions workflow that:
  - Runs `tofu fmt -check` to ensure code formatting
  - Initializes OpenTofu with Terraform Cloud backend
  - Validates configuration
  - Plans changes on all PRs and pushes
  - Auto-applies on merge to main branch

## Important Conventions

### DNS Records

- Simple records (A, AAAA, CNAME, MX) can be defined in `records.csv`
- Complex records (TXT with special characters, CAA) should be added directly to `main.tf`
- Always include comments in format: `owner=<name> | source=<source> | comment=<description>`
- Use `proxied = "false"` for non-proxied records, `"true"` for proxied (A/AAAA/CNAME only)
- TTL of 1 means "auto" in Cloudflare

### Git Workflow

- **Main branch**: `main` - protected, requires PRs
- **Feature branches**: Should start with `claude/` for Claude Code work
- **Branch naming**: Use descriptive names like `claude/update-dns-records-K7VET`
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

Variables defined in `variables.tf`:
- `cloudflare_api_token`: Cloudflare authentication
- `cloudflare_zone_id`: The Cloudflare zone ID for the domain

## Common Development Tasks

### Adding a New DNS Record

1. For simple records, edit `dns/cloudflare/records.csv` (when implemented)
2. For complex records, add to `dns/cloudflare/terraform/main.tf`:
   ```hcl
   resource "cloudflare_dns_record" "example" {
     zone_id = var.cloudflare_zone_id
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
cd dns/cloudflare/terraform
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
6. GitHub Actions will run plan and show expected changes
7. Review the plan output
8. Merge PR to trigger automatic apply

## Important Notes for Claude Code

### When Making Changes

- **Always read files before editing**: Use Read tool before Edit tool
- **Format before committing**: Run `tofu fmt` on modified `.tf` files
- **Test locally when possible**: Run `tofu plan` to validate changes
- **Use existing patterns**: Follow the comment format and structure of existing resources
- **Avoid over-engineering**: Keep changes simple and focused on the request
- **Don't add unnecessary features**: Only implement what's requested

### Git Operations

- **Branch naming**: Must start with `claude/` and end with session ID for successful push
- **Push command**: Always use `git push -u origin <branch-name>`
- **Retry on network errors**: Up to 4 retries with exponential backoff (2s, 4s, 8s, 16s)
- **Never push to main directly**: Always use PRs

### Security Considerations

- Never commit secrets or sensitive values
- Don't modify `.gitignore` to expose sensitive files
- Keep API tokens in GitHub secrets only
- Review all changes before pushing
- Validate that no sensitive data is in commit history

### OpenTofu/Terraform Specifics

- **Provider version**: Locked to Cloudflare v5.15.0 - don't change without testing
- **OpenTofu version**: Using 1.11.0 - specified in GitHub Actions
- **State management**: Handled by Terraform Cloud - never commit state files
- **Backend**: Configured in `backend.tf` - don't modify without coordination

## Testing Strategy

- **Automated**: GitHub Actions runs fmt check, init, validate, and plan on all PRs
- **Manual**: Local testing with `tofu plan` before pushing
- **Deployment verification**: Check Cloudflare dashboard after apply to confirm changes

## Troubleshooting

### Common Issues

1. **Format check fails**: Run `tofu fmt` locally before committing
2. **Authentication errors**: Check that secrets are properly configured in GitHub
3. **Plan fails**: Validate configuration locally with `tofu validate`
4. **State lock errors**: Check Terraform Cloud workspace for stuck locks
5. **Push fails with 403**: Ensure branch name starts with `claude/` and ends with session ID

## Future Enhancements

Based on README.md, planned improvements include:
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
- Repository README: See `README.md` for detailed setup instructions
