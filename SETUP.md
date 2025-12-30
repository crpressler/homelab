# Setup Checklist

Follow these steps to get your DNS management system up and running.

## Step 1: Terraform Cloud Setup

- [x] Create account at https://app.terraform.io
- [x] Create an organization
- [x] Update organization name in `dns/cloudflare/terraform/backend.tf`
- [x] Generate API token (User Settings → Tokens)
- [x] Save token (you'll need it for GitHub secrets)

## Step 2: Cloudflare Setup

- [x] Log in to Cloudflare Dashboard
- [x] Go to Profile → API Tokens
- [x] Create Token → Use "Edit zone DNS" template
- [x] Select your domain zone
- [x] Save the API token
- [x] Go to your domain Overview page
- [x] Copy the Zone ID

## Step 3: GitHub Repository Setup

- [x] Push this code to your GitHub repository
- [x] Go to Settings → Secrets and variables → Actions
- [x] Add secret: `TF_API_TOKEN` (from Step 1)
- [x] Add secret: `CLOUDFLARE_API_TOKEN` (from Step 2)
- [x] Add secret: `CLOUDFLARE_ZONE_ID` (from Step 2)
- [ ] (Optional) Enable branch protection on `main` branch

## Step 4: Local Development Setup

- [x] Install OpenTofu: https://opentofu.org/docs/intro/install/
- [x] Clone repository locally
- [ ] Navigate to `dns/cloudflare/terraform/`
- [ ] Run `tofu login` to authenticate with Terraform Cloud
- [ ] Copy `terraform.tfvars.example` to `terraform.tfvars`
- [ ] Edit `terraform.tfvars` with your Cloudflare credentials
- [ ] Run `tofu init`
- [ ] Run `tofu plan` to verify setup

## Step 5: Add Your DNS Records

- [ ] Edit `dns/cloudflare/records.csv`
- [ ] Remove or uncomment example records
- [ ] Add your actual DNS records
- [ ] Test locally with `tofu plan` (run from `dns/cloudflare/terraform/`)

## Step 6: Deploy via GitHub

- [ ] Create a new branch
- [ ] Commit your changes to `records.csv`
- [ ] Push and create a Pull Request
- [ ] Review the plan output in PR comments
- [ ] Merge PR to apply changes

## Verification

After merging your first PR:

- [ ] Check GitHub Actions completed successfully
- [ ] Verify DNS records in Cloudflare Dashboard
- [ ] Test DNS resolution with `nslookup` or `dig`

## Troubleshooting

If something goes wrong:

1. Check GitHub Actions logs for detailed error messages
2. Verify all secrets are set correctly in GitHub
3. Ensure Cloudflare API token has correct permissions
4. Verify Zone ID matches your domain
5. Check CSV format (no extra spaces, correct columns)

## Next Steps

- Set up branch protection to require PR reviews
- Add more domains/zones as needed
- Consider adding DNS validation scripts
- Set up monitoring for DNS changes

## Support

- OpenTofu Documentation: https://opentofu.org/docs/
- Cloudflare Terraform Provider: https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs
- GitHub Actions: https://docs.github.com/en/actions
