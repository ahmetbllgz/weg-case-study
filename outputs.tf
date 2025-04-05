output "cluster_endpoint" {
  description = "The endpoint of the GKE cluster"
  value       = google_container_cluster.primary.endpoint
}

output "cluster_name" {
  description = "The name of the GKE cluster"
  value       = google_container_cluster.primary.name
}

output "monitoring_namespace" {
  description = "The namespace where Prometheus and Grafana are deployed"
  value       = "monitoring"
}
