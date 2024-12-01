# variables.tf for Kubernetes Resources Deployment

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "app_hostname" {
  description = "Hostname for the application ingress"
  type        = string
  default     = "hospital.local"
}

variable "mongodb_image_repository" {
  description = "MongoDB image repository"
  type        = string
  default     = "mongo"
}

variable "mongodb_image_tag" {
  description = "MongoDB image tag"
  type        = string
  default     = "6.0"
}

variable "frontend_image_repository" {
  description = "Frontend image repository"
  type        = string
  default     = "ahmadsattar78677/web-frontend"
}

variable "frontend_image_tag" {
  description = "Frontend image tag"
  type        = string
  default     = "v0"
}

variable "backend_image_repository" {
  description = "Backend image repository"
  type        = string
  default     = "ahmadsattar78677/web-backend"
}

variable "backend_image_tag" {
  description = "Backend image tag"
  type        = string
  default     = "v0"
}

variable "db_uri" {
  description = "MongoDB URI"
  type        = string
  default     = "mongodb://mongodb:27017/hospital"
}

variable "jwt_secret" {
  description = "JWT secret"
  type        = string
  default     = "MTIzNDU="
}

