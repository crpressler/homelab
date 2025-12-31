terraform {
  required_version = ">= 1.6.0"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.15.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# # Create records
# resource "cloudflare_dns_record" "resource_name" {
#   zone_id = var.cloudflare_zone_id
#   name    = "record-name"
#   type    = "A"
#   content = "1.2.3.4"
#   ttl     = 1
#   proxied = "false"
#   comment = "owner=crpressler | source=manual | comment=Manually created test record"
# }

resource "cloudflare_dns_record" "tf-test" {
  zone_id = var.cloudflare_zone_id
  name    = "tf-test"
  type    = "A"
  content = "1.2.3.4"
  ttl     = 1
  proxied = "false"
  comment = "owner=crpressler | source=manual | comment=Manually created test record"
}

