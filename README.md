# Homelab Infrastructure as Code

This repository manages my homelab infrastructure using Infrastructure as Code practices.

## DNS Management with Cloudflare

Manage DNS records in Cloudflare using OpenTofu.

### Features

- DNS records defined in OpenTofu configuration
- Automated deployment via GitHub Actions
- Plan on Pull Requests, Apply on merge to main
- State stored remotely in Terraform Cloud
- Support for A, AAAA, CNAME, TXT, MX, and other record types
- Cloudflare proxy support
- TTL and comment configuration per record

### Directory Structure

```
homelab/
├── dns/
│   └── cloudflare/
│       ├── records.csv              # DNS records definition (future use)
│       └── terraform/
│           ├── main.tf              # Main OpenTofu configuration with DNS records
│           ├── variables.tf         # Variable definitions
│           └── terraform.tfvars     # Variable values (non-sensitive)
└── .github/
    └── workflows/
        └── opentofu.yml             # OpenTofu workflow (plan on PR, apply on merge)
```

## Setup Instructions

### Prerequisites

- [OpenTofu](https://opentofu.org/) installed (v1.6+)
- Cloudflare account with a domain
- Terraform Cloud account (free tier)
- GitHub repository with Actions enabled

### 1. Terraform Cloud Setup

1. Create a free account at [Terraform Cloud](https://app.terraform.io)
2. Create an organization
3. Update `dns/cloudflare/terraform/backend.tf` with your organization name
4. Generate an API token:
   - Go to User Settings → Tokens
   - Create an API token
   - Save it as a GitHub secret named `TF_API_TOKEN`

### 2. Cloudflare Setup

1. Get your Cloudflare API Token:
   - Log in to Cloudflare Dashboard
   - Go to Profile → API Tokens
   - Create Token → Edit zone DNS template
   - Select your domain zone
   - Save the token as a GitHub secret named `CLOUDFLARE_API_TOKEN`

2. Get your Zone ID:
   - Go to your domain in Cloudflare
   - Scroll down on the Overview page
   - Copy the Zone ID
   - Save it as a terraform variable named `CLOUDFLARE_ZONE_ID`

### 3. Local Development Setup

1. Clone the repository:
   ```bash
   git clone <your-repo-url>
   cd homelab
   ```

2. Initialize OpenTofu:
   ```bash
   cd dns/cloudflare/terraform
   tofu login  # Authenticate with Terraform Cloud
   tofu init
   ```

3. Create your variables file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

### 4. GitHub Secrets Configuration

Add these secrets to your GitHub repository (Settings → Secrets and variables → Actions):

- `TF_API_TOKEN`: Your Terraform Cloud API token
- `CLOUDFLARE_API_TOKEN`: Your Cloudflare API token

## Usage

### Adding/Modifying DNS Records

**Simple records** (A, AAAA, CNAME, MX):
1. Edit `dns/cloudflare/records.csv`
2. Add or modify records following the CSV format:

```csv
name,type,value,ttl,proxied,comment
@,A,192.0.2.1,3600,true,Main website
www,CNAME,example.com,3600,true,WWW subdomain
mail,A,192.0.2.2,3600,false,Mail server
@,MX,10 mail.example.com,3600,false,Mail exchanger
```

**Complex records** (TXT with special characters, CAA, etc.):
- Edit `dns/cloudflare/terraform/main.tf`
- Add additional records using the OpenTofu resource syntax
- Use this for records that break CSV parsing (commas, quotes, semicolons)

### CSV Format

- **name**: Record name (use `@` for root domain)
- **type**: Record type (A, AAAA, CNAME, TXT, MX, etc.)
- **value**: Record value (for MX records: `priority target`)
- **ttl**: Time to live in seconds (1 = auto)
- **proxied**: `true` or `false` (only for A/AAAA/CNAME)
- **comment**: Optional comment for documentation

### Workflow

#### Local Testing

```bash
cd dns/cloudflare/terraform

# Format check
tofu fmt

# Validate configuration
tofu validate

# See what changes will be made
tofu plan

# Apply changes (if you're confident)
tofu apply
```

#### Production Deployment

1. Create a new branch:
   ```bash
   git checkout -b update-dns-records
   ```

2. Edit `dns/cloudflare/records.csv` with your changes

3. Commit and push:
   ```bash
   git add dns/cloudflare/records.csv
   git commit -m "Update DNS records for XYZ"
   git push origin update-dns-records
   ```

4. Create a Pull Request
   - GitHub Actions will run `tofu plan`
   - Review the planned changes in the PR comment

5. Merge the PR
   - GitHub Actions will automatically run `tofu apply`
   - DNS records will be updated in Cloudflare

## GitHub Actions Workflows

### OpenTofu (`opentofu.yml`)

Triggers on pull requests and pushes to main:
- Runs `tofu fmt -check`
- Runs `tofu init`
- Runs `tofu validate`
- Runs `tofu plan`
- On merge to main: Runs `tofu apply -auto-approve`
- Updates DNS records in Cloudflare

## Security Best Practices

- Never commit `terraform.tfvars` or any file containing secrets
- Use GitHub secrets for sensitive values
- Review all changes in Pull Requests before merging
- Enable branch protection on `main` to require PR reviews
- Regularly rotate API tokens
- Use least-privilege API tokens (DNS edit only)

## Troubleshooting

### Plan/Apply fails with authentication error

- Verify GitHub secrets are set correctly
- Check that Terraform Cloud token is valid
- Ensure Cloudflare API token has DNS edit permissions

### Records not updating

- Check GitHub Actions logs for errors
- Verify Zone ID matches your domain
- Ensure CSV format is correct (no extra spaces)

### State lock errors

- Terraform Cloud handles locking automatically
- If stuck, check workspace in Terraform Cloud console

## Future Enhancements

- [ ] Add support for multiple domains/zones
- [ ] Implement DNS record validation
- [ ] Add pre-commit hooks for CSV validation
- [ ] Create scripts for bulk record management
- [ ] Add monitoring/alerting for DNS changes

## License

MIT License - See [LICENSE](LICENSE) file for details
