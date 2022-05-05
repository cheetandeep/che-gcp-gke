module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 2.5"

  project_id   = module.gke_project.project_id
  network_name = var.network_name
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name           = var.subnet_name
      subnet_ip             = var.subnet_ip
      subnet_region         = var.region
      subnet_flow_logs      = "true"
      subnet_private_access = true
      description           = "This subnet is used by our GKE cluster"
    }
  ]
  secondary_ranges = {
    (var.subnet_name) = [
      {
        range_name    = var.ip_range_pods_name
        ip_cidr_range = var.ip_pods_cidr_range
      },
      {
        range_name    = var.ip_range_services_name
        ip_cidr_range = var.ip_services_cidr_range
      },
    ]
  }
}


module "cloud-nat" {
  source        = "terraform-google-modules/cloud-nat/google"
  version       = "~> 1.2"
  project_id    = module.gke_project.project_id
  region        = var.region
  router        = "${local.cluster_type}-${var.cluster_name}-router"
  network       = module.vpc.network_self_link
  create_router = true
}
