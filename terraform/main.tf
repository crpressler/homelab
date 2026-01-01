# main.tf imports child modules
# non-root resources are defined in child modules

module "cloudflare" {
  source                            = "./dns/cloudflare"
  cloudflare_zone_id_pressler_cloud = var.cloudflare_zone_id_pressler_cloud
}