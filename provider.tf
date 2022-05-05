provider "google" {
  version = "~> 3.52.0"
}

provider "google-beta" {
  version = "~> 3.79.0"
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}
