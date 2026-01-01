# Homelab Infrastructure

Infrastructure as Code for managing homelab DNS records using OpenTofu and Cloudflare.

## Overview

This repository manages DNS records for the `pressler.cloud` domain using OpenTofu (Terraform fork) with automated deployment via GitHub Actions. All infrastructure state is managed remotely through Terraform Cloud.

## Features

- **Automated Deployment**: GitHub Actions workflow handles formatting, validation, planning, and deployment
- **Modular Architecture**: Organized module structure for scalability
- **Remote State**: Terraform Cloud backend for reliable state management
- **DNS Management**: Cloudflare DNS records managed as code

## Quick Start

### Prerequisites

- [OpenTofu](https://opentofu.org/) v1.11.0 or later
- Cloudflare account with API token
- Terraform Cloud account

### Local Development

1. Clone the repository:
```bash
git clone <repository-url>
cd homelab
```

2. Set up environment variables:
```bash
cp terraform/terraform.tfvars.example terraform/terraform.tfvars
# Edit terraform.tfvars with your zone ID
```

3. Configure Cloudflare API token:
```bash
echo 'TF_VAR_cloudflare_api_token=your_token_here' > .env
source .env
```

4. Initialize and validate:
```bash
cd terraform
tofu login  # Authenticate with Terraform Cloud
tofu init
tofu validate
tofu plan
```

### Adding DNS Records

DNS records are defined in `terraform/dns/cloudflare/cloudflare.tf`. To add a new record:

1. Create a feature branch:
```bash
git checkout -b feature/add-dns-record
```

2. Edit `terraform/dns/cloudflare/cloudflare.tf`:
```hcl
resource "cloudflare_dns_record" "example" {
  zone_id = local.zone_id
  name    = "subdomain"
  type    = "A"
  content = "1.2.3.4"
  ttl     = 1
  proxied = "false"
  comment = "owner=yourname | source=manual | comment=Description"
}
```

3. Format and validate:
```bash
tofu fmt
tofu validate
tofu plan
```

4. Commit and push:
```bash
git add terraform/dns/cloudflare/cloudflare.tf
git commit -m "Add DNS record for subdomain"
git push -u origin feature/add-dns-record
```

5. Create a Pull Request and review the plan output in GitHub Actions

6. Merge to `main` to automatically apply changes

## Repository Structure

```
homelab/
├── terraform/                    # Root terraform directory
│   ├── dns/cloudflare/          # Cloudflare DNS module
│   ├── main.tf                  # Root module
│   ├── providers.tf             # Provider configuration
│   ├── variables.tf             # Variable declarations
│   ├── backend.tf               # Terraform Cloud backend
│   └── terraform.tfvars         # Variable values
├── .github/workflows/           # CI/CD workflows
└── README.md                    # This file
```

## CI/CD Pipeline

The GitHub Actions workflow automatically:
- **On Pull Request**: Runs format check, init, validate, and plan
- **On Merge to Main**: Applies changes to infrastructure

### Required Secrets

Configure these secrets in your GitHub repository settings:
- `CLOUDFLARE_API_TOKEN`: Cloudflare API token with DNS edit permissions
- `TF_API_TOKEN`: Terraform Cloud API token

## Technology Stack

- **IaC Tool**: OpenTofu v1.11.0
- **DNS Provider**: Cloudflare (Provider v5.15.0)
- **State Backend**: Terraform Cloud
- **CI/CD**: GitHub Actions

## Contributing

1. Create a feature branch from `main`
2. Make your changes
3. Run `tofu fmt` and `tofu validate`
4. Test with `tofu plan`
5. Submit a Pull Request

## License

MIT License - See [LICENSE](LICENSE) file for details

## Additional Documentation

For detailed technical documentation and Claude Code integration, see [CLAUDE.MD](CLAUDE.MD).
