terraform {
  cloud {
    hostname     = "app.terraform.io"
    organization = "pressler-cloud"

    workspaces {
      name = "homelab-dns-cloudflare"
    }
  }
}
