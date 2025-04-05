variable "project_id" {
  description = "GCP project ID"
  type        = string
  default     = "weg-case-study"
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "europe-west1"
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "gke-cluster"
}

variable "machine_type" {
  description = "Machine type for node pools"
  type        = string
  default     = "n2d-standard-2"
}


variable "credentials_file" {
    description = "Credentials file for GCP"
    type= string
    default= "/home/verius/.config/gcloud/application_default_credentials.json"
}

variable "grafana_admin_password" {
  description = "Grafana admin password, replace the default value for a more secure application"
  type        = string
  default     = "admin"
}

variable "kube_prometheus_stack_version" {
  description = "Helm chart version for kube-prometheus-stack"
  type        = string
  default     = "70.4.1"
}