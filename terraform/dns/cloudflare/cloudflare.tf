# Main pressler.cloud zone records

locals {
  zone_id = var.cloudflare_zone_id_pressler_cloud
}


# # Create records
# resource "cloudflare_dns_record" "resource_name" {
#   zone_id = var.cloudflare_zone_id
#   name    = "record-name"
#   type    = "A"
#   content = "1.2.3.4"
#   ttl     = 1
#   proxied = "false"
#   comment = "owner=crpressler | source=manual | comment=(Service if relevant) Manually created test record"
# }

resource "cloudflare_dns_record" "tf-test" {
  zone_id = local.zone_id
  name    = "tf-test"
  type    = "A"
  content = "1.2.3.4"
  ttl     = 1
  proxied = "false"
  comment = "owner=crpressler | source=manual | comment=Manually created test record"
}

