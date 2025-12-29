variable "cloudflare_api_token" {
  description = "Cloudflare API Token with DNS edit permissions"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID for your domain"
  type        = string
}

variable "dns_records_file" {
  description = "Path to the CSV file containing DNS records"
  type        = string
  default     = "../records.csv"
}
