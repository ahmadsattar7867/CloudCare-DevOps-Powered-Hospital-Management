# variables.tf for GKE Cluster Creation

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "hospital-gke-cluster"
}

variable "ip_range_pods_name" {
  description = "The secondary ip range name for pods"
  type        = string
  default     = "ip-range-pods"
}

variable "ip_range_services_name" {
  description = "The secondary ip range name for services"
  type        = string
  default     = "ip-range-services"
}

