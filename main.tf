resource "google_container_cluster" "primary" {
  name                     = var.cluster_name
  location                 = var.region
  remove_default_node_pool = true
  initial_node_count       = 1

  # Disable logging and monitoring by setting empty enable_components lists.
  logging_config {
    enable_components = []
  }

  monitoring_config {
    enable_components = []
  }
}

# Main node pool without autoscaling (fixed size)
resource "google_container_node_pool" "main_pool" {
  name     = "main-pool"
  cluster  = google_container_cluster.primary.name
  location = google_container_cluster.primary.location

  node_config {
    machine_type = var.machine_type
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    resource_labels = {
      "goog-gke-node-pool-provisioning-model" = "on-demand"
    }
    kubelet_config {
      cpu_manager_policy = "none"
      cpu_cfs_quota  = false
      pod_pids_limit = 0
    }
  }

  lifecycle {
    ignore_changes = [
      node_config[0].resource_labels,
      node_config[0].kubelet_config,
    ]
  }
}

# Application node pool with autoscaling enabled
resource "google_container_node_pool" "application_pool" {
  name     = "application-pool"
  cluster  = google_container_cluster.primary.name
  location = google_container_cluster.primary.location

  node_config {
    machine_type = var.machine_type
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    resource_labels = {
      "goog-gke-node-pool-provisioning-model" = "on-demand"
    }
    kubelet_config {
      cpu_manager_policy = "none"
      cpu_cfs_quota  = false
      pod_pids_limit = 0
    }
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  lifecycle {
    ignore_changes = [
      node_config[0].resource_labels,
      node_config[0].kubelet_config,
    ]
  }
}

