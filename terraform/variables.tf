variable "cloudflare_api_token" {
  description = "Cloudflare API token for authentication"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id_pressler_cloud" {
  description = "Zone ID for pressler.cloud"
  type        = string
}
