# Terraform Cloud/HCP backend configuration
# Before using this, you need to:
# 1. Create a free account at https://app.terraform.io
# 2. Create an organization
# 3. Update the organization name below
# 4. Run: tofu login

terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "pressler-cloud"
    token = "xxx.atlasv1.yyy"

    workspaces {
      name = "${TF_API_TOKEN}"
    }
  }
}
