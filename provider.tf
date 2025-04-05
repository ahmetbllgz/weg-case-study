provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file(var.credentials_file)
}

provider "kubectl" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
