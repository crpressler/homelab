terraform {
  required_version = ">= 1.6"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }

  # Remote state backend - configure based on your preference
  # Example for Terraform Cloud:
  # cloud {
  #   organization = "your-org-name"
  #   workspaces {
  #     name = "homelab-dns"
  #   }
  # }

  # Example for S3:
  # backend "s3" {
  #   bucket = "your-terraform-state-bucket"
  #   key    = "homelab/dns/terraform.tfstate"
  #   region = "us-east-1"
  # }

  # Example for Cloudflare R2:
  # backend "s3" {
  #   bucket = "terraform-state"
  #   key    = "homelab/dns/terraform.tfstate"
  #   region = "auto"
  #   skip_credentials_validation = true
  #   skip_region_validation      = true
  #   skip_requesting_account_id  = true
  #   endpoints = {
  #     s3 = "https://<account-id>.r2.cloudflarestorage.com"
  #   }
  # }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# Read and parse the CSV file
locals {
  dns_records_csv = file(var.dns_records_file)

  # Parse CSV, skip header and comment lines
  dns_records_lines = [
    for line in split("\n", local.dns_records_csv) :
    line if !startswith(trimspace(line), "#") && trimspace(line) != "" && !startswith(line, "name,")
  ]

  # Convert CSV to map of records
  dns_records = {
    for idx, line in local.dns_records_lines :
    idx => {
      name    = split(",", line)[0]
      type    = split(",", line)[1]
      value   = split(",", line)[2]
      ttl     = try(tonumber(split(",", line)[3]), 3600)
      proxied = try(tobool(split(",", line)[4]), false)
      comment = try(split(",", line)[5], "")
    }
  }
}

# Create DNS records from CSV
resource "cloudflare_record" "dns_records" {
  for_each = local.dns_records

  zone_id = var.cloudflare_zone_id
  name    = each.value.name
  type    = each.value.type

  # Handle different record types
  content = each.value.type == "MX" ? split(" ", each.value.value)[1] : each.value.value

  # MX records need priority
  priority = each.value.type == "MX" ? tonumber(split(" ", each.value.value)[0]) : null

  ttl     = each.value.ttl
  proxied = each.value.type == "A" || each.value.type == "AAAA" || each.value.type == "CNAME" ? each.value.proxied : false

  comment = each.value.comment != "" ? each.value.comment : null
}
