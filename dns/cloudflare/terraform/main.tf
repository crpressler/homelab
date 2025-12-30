terraform {
  cloud {
    hostname     = "app.terraform.io"
    organization = "pressler-cloud"

    workspaces {
      name = "homelab-dns-cloudflare"
    }
  }
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# Create records
resource "cloudflare_dns_record" "test" {
  zone_id = var.cloudflare_zone_id
  name    = "tf-test"
  type    = "A"
  content = "1.2.3.4"
  ttl     = 1
  proxied = "false"
  comment = "Testing Terraform functionality"
}

