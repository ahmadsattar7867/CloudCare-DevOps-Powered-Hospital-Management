# main.tf for Kubernetes Resources Deployment

data "google_container_cluster" "my_cluster" {
  name     = var.cluster_name
  location = var.region
}

resource "helm_release" "hospital_app" {
  name             = "hospital-app"
  chart            = "../../helm/hospital-chart"
  namespace        = "default"
  create_namespace = true
  timeout          = 600 # Increase timeout to 10 minutes

  set {
    name  = "mongodb.image.repository"
    value = var.mongodb_image_repository
  }

  set {
    name  = "mongodb.image.tag"
    value = var.mongodb_image_tag
  }

  set {
    name  = "hospitalApp.frontend.image.repository"
    value = var.frontend_image_repository
  }

  set {
    name  = "hospitalApp.frontend.image.tag"
    value = var.frontend_image_tag
  }

  set {
    name  = "hospitalApp.backend.image.repository"
    value = var.backend_image_repository
  }

  set {
    name  = "hospitalApp.backend.image.tag"
    value = var.backend_image_tag
  }

  set {
    name  = "config.dbUri"
    value = var.db_uri
  }

  set {
    name  = "config.jwtSecret"
    value = var.jwt_secret
  }

  set {
    name  = "ingress.hostname"
    value = var.app_hostname
  }

  # Add debug settings
  set {
    name  = "debug"
    value = "true"
  }

  # Force resource recreation
  recreate_pods = true

  # Add wait condition
  wait          = true
  wait_for_jobs = true
}



resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "3.35.4"

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }
}

resource "kubectl_manifest" "argocd_application" {
  yaml_body = file("${path.module}/application.yaml")

  depends_on = [helm_release.argocd]
}


