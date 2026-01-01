module "cloudflare" {
  source = "./dns/cloudflare"

  cloudflare_zone_id_pressler_cloud = var.cloudflare_zone_id_pressler_cloud
}