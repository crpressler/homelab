# Cloudflare DNS Management

This directory contains DNS records and OpenTofu configuration for managing them in Cloudflare.

## Quick Start

### First Time Setup

1. Update [terraform/backend.tf](terraform/backend.tf) with your Terraform Cloud organization name
2. Navigate to the terraform directory and copy the example variables file:
   ```bash
   cd terraform
   cp terraform.tfvars.example terraform.tfvars
   ```
3. Edit `terraform.tfvars` with your Cloudflare credentials
4. Initialize OpenTofu:
   ```bash
   tofu login
   tofu init
   ```

### Adding DNS Records

**Simple records** - Edit [records.csv](records.csv) for basic records:

```csv
# A record for root domain
@,A,192.0.2.1,3600,true,Main website

# CNAME for subdomain
www,CNAME,example.com,3600,true,WWW subdomain

# Mail server (not proxied)
mail,A,192.0.2.2,3600,false,Mail server

# MX record (format: priority target)
@,MX,10 mail.example.com,3600,false,Mail exchanger
```

**Complex records** - Edit [terraform/additional_records.tf](terraform/additional_records.tf) for:
- TXT records with commas, semicolons, or quotes (SPF, DKIM, DMARC)
- CAA records
- Any record causing CSV parsing issues
- Multiple TXT records with the same name

See the file for examples and uncomment/modify as needed.

### Testing Changes

```bash
cd terraform

# Format code
tofu fmt

# Validate configuration
tofu validate

# Preview changes
tofu plan

# Apply changes
tofu apply
```

## CSV Column Reference

| Column | Required | Description | Example |
|--------|----------|-------------|---------|
| name | Yes | Record name (use `@` for root) | `www`, `mail`, `@` |
| type | Yes | DNS record type | `A`, `CNAME`, `TXT`, `MX` |
| value | Yes | Record value | `192.0.2.1`, `example.com` |
| ttl | Yes | Time to live (seconds, 1=auto) | `3600`, `1` |
| proxied | Yes | Proxy through Cloudflare (A/AAAA/CNAME only) | `true`, `false` |
| comment | No | Documentation/notes | `Production server` |

## Record Type Examples

### A Record
```csv
@,A,192.0.2.1,3600,true,Main site
```

### AAAA Record (IPv6)
```csv
@,AAAA,2001:db8::1,3600,true,Main site IPv6
```

### CNAME
```csv
www,CNAME,example.com,3600,true,WWW redirect
```

### MX Record
```csv
@,MX,10 mail.example.com,3600,false,Primary mail server
@,MX,20 backup-mail.example.com,3600,false,Backup mail server
```

### TXT Record
```csv
@,TXT,v=spf1 include:_spf.google.com ~all,3600,false,SPF record
```

### CAA Record
```csv
@,CAA,0 issue "letsencrypt.org",3600,false,SSL certificate authority
```

## Files

- [records.csv](records.csv) - Simple DNS records (A, AAAA, CNAME, MX)
- [terraform/main.tf](terraform/main.tf) - Main OpenTofu configuration (reads CSV)
- [terraform/additional_records.tf](terraform/additional_records.tf) - Complex records (TXT, CAA, etc.)
- [terraform/variables.tf](terraform/variables.tf) - Input variables
- [terraform/outputs.tf](terraform/outputs.tf) - Output values
- [terraform/backend.tf](terraform/backend.tf) - Remote state backend
- [terraform/terraform.tfvars.example](terraform/terraform.tfvars.example) - Example variables file

## Important Notes

- **CSV records**: Lines starting with `#` in CSV are treated as comments
- The header line (`name,type,value...`) is automatically skipped
- Proxied setting only works for A, AAAA, and CNAME records
- MX records require priority in the value field: `10 mail.example.com`
- **Complex records**: Use `terraform/additional_records.tf` for TXT/CAA records with special characters
- **Security**: Never commit `terraform.tfvars` - it contains secrets
- **Testing**: Always test with `tofu plan` before applying
