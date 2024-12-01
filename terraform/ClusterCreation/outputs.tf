# outputs.tf for GKE Cluster Creation

output "cluster_endpoint" {
  description = "Endpoint for GKE control plane"
  value       = module.gke.endpoint
}

output "cluster_ca_certificate" {
  description = "Public certificate authority of the cluster"
  value       = module.gke.ca_certificate
}

output "region" {
  description = "GCP region"
  value       = var.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.gke.name
}

