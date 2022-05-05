locals {
  cluster_type    = "private"
  gke_bucket_name = "gke-bucket"
}

resource "google_folder" "gke_cluster" {
  display_name = "gke"
  parent       = "organizations/${var.organization_id}"
}

module "gke_project" {
  source            = "terraform-google-modules/project-factory/google"
  name              = "gke-cluster"
  random_project_id = true
  org_id            = var.organization_id
  billing_account   = var.billing_account
  folder_id         = google_folder.gke_cluster.id
  activate_apis = [
    "iam.googleapis.com",
    "compute.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "containerregistry.googleapis.com",
    "container.googleapis.com",
    "binaryauthorization.googleapis.com",
    "stackdriver.googleapis.com",
    "iap.googleapis.com",
  ]
}

module "gke_tfstate_bucket" {
  source  = "terraform-google-modules/cloud-storage/google"
  version = "~> 1.7"

  admins          = ["group:${var.group_org_admins}"]
  names           = [local.gke_bucket_name]
  prefix          = ""
  set_admin_roles = true
  storage_class   = "STANDARD"

  location   = var.region
  project_id = module.gke_project.project_id

  versioning = {
    (local.gke_bucket_name) = true
  }
}

module "gke" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster"

  project_id              = module.gke_project.project_id
  name                    = "${local.cluster_type}-${var.cluster_name}-cluster"
  region                  = var.region
  network                 = module.vpc.network_name
  subnetwork              = module.vpc.subnets_names[0]
  ip_range_pods           = module.vpc.subnets_secondary_ranges[0].*.range_name[0]
  ip_range_services       = module.vpc.subnets_secondary_ranges[0].*.range_name[1]
  enable_private_endpoint = false
  enable_private_nodes    = true
  cloudrun                = true
  master_authorized_networks = [{
    cidr_block   = "${module.bastion.ip_address}/32"
    display_name = "Bastion Host"
  }]
  node_pools = [
    {
      name          = "${local.cluster_type}-${var.cluster_name}-nodepool"
      min_count     = 1
      max_count     = 2
      auto_upgrade  = true
      auto_repair   = true
      node_metadata = "GKE_METADATA_SERVER"
      image_type    = "COS"
    }
  ]
}
