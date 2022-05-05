variable "project_id" {
  type        = string
  description = "The project ID to host the cluster in"
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
  default     = "gke"
}

variable "region" {
  type        = string
  description = "The region for the GCP resources"
}

variable "network_name" {
  type        = string
  description = "The name of the network being created to host the cluster in"
}

variable "subnet_name" {
  type        = string
  description = "The name of the subnet being created to host the cluster in"
}

variable "subnet_ip" {
  type        = string
  description = "The cidr range of the subnet"
}

variable "ip_range_pods_name" {
  type        = string
  description = "The secondary ip range to use for pods"
  default     = "ip-range-pods"
}

variable "ip_range_services_name" {
  type        = string
  description = "The secondary ip range to use for pods"
  default     = "ip-range-svc"
}

variable "bastion_members" {
  type        = list(string)
  description = "List of users, groups, SAs who need access to the bastion host"
  default     = []
}

variable "ip_source_ranges_ssh" {
  type        = list(string)
  description = "Additional source ranges to allow for ssh to bastion host. 35.235.240.0/20 allowed by default for IAP tunnel."
  default     = []
}

variable "ip_pods_cidr_range" {
  type        = string
  description = "The CIDR for the Pod IP address range"
}
variable "ip_services_cidr_range" {
  type        = string
  description = "The CIDR for the Service IP address range"
}

## Bucket and projects
variable "organization_id" {
  description = "The organization id for the associated services"
}

variable "billing_account" {
  description = "The ID of the billing account to associate this project with"
}

variable "group_org_admins" {
  description = "Group Admins of GCP resources"
  type        = string
}
