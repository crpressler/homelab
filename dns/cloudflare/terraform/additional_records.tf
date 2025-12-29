# Additional DNS Records
# Use this file for records that don't work well in CSV format:
# - TXT records with commas, quotes, or special characters
# - Complex SPF/DKIM/DMARC records
# - CAA records
# - Any record that causes CSV parsing issues
#
# HOW TO USE:
# 1. Uncomment the examples below
# 2. Modify the values for your domain
# 3. Save the file
# 4. Run: tofu plan (to preview) and tofu apply (to deploy)
#
# Each resource needs a unique name (e.g., "spf", "dmarc", "txt_record_1")

# Example TXT records (uncomment and modify as needed):

# resource "cloudflare_record" "spf" {
#   zone_id = var.cloudflare_zone_id
#   name    = "@"
#   type    = "TXT"
#   content = "v=spf1 include:_spf.google.com include:_spf.example.com ~all"
#   ttl     = 3600
#   comment = "SPF record for email authentication"
# }

# resource "cloudflare_record" "dmarc" {
#   zone_id = var.cloudflare_zone_id
#   name    = "_dmarc"
#   type    = "TXT"
#   content = "v=DMARC1; p=quarantine; rua=mailto:dmarc@example.com; ruf=mailto:dmarc@example.com; fo=1"
#   ttl     = 3600
#   comment = "DMARC policy"
# }

# resource "cloudflare_record" "dkim" {
#   zone_id = var.cloudflare_zone_id
#   name    = "default._domainkey"
#   type    = "TXT"
#   content = "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC..."
#   ttl     = 3600
#   comment = "DKIM public key"
# }

# resource "cloudflare_record" "site_verification" {
#   zone_id = var.cloudflare_zone_id
#   name    = "@"
#   type    = "TXT"
#   content = "google-site-verification=abc123xyz"
#   ttl     = 3600
#   comment = "Google site verification"
# }

# CAA record example:
# resource "cloudflare_record" "caa_letsencrypt" {
#   zone_id = var.cloudflare_zone_id
#   name    = "@"
#   type    = "CAA"
#   ttl     = 3600
#   comment = "Let's Encrypt CAA record"
#
#   data {
#     flags = "0"
#     tag   = "issue"
#     value = "letsencrypt.org"
#   }
# }

# Multiple TXT records for the same name:
# resource "cloudflare_record" "txt_record_1" {
#   zone_id = var.cloudflare_zone_id
#   name    = "@"
#   type    = "TXT"
#   content = "v=spf1 include:_spf.google.com ~all"
#   ttl     = 3600
# }
#
# resource "cloudflare_record" "txt_record_2" {
#   zone_id = var.cloudflare_zone_id
#   name    = "@"
#   type    = "TXT"
#   content = "google-site-verification=abc123"
#   ttl     = 3600
# }
