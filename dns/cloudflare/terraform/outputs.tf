output "dns_records" {
  description = "Map of created DNS records"
  value = {
    for k, v in cloudflare_record.dns_records :
    k => {
      name     = v.name
      type     = v.type
      value    = v.content
      proxied  = v.proxied
      hostname = v.hostname
    }
  }
}

output "record_count" {
  description = "Number of DNS records managed"
  value       = length(cloudflare_record.dns_records)
}
