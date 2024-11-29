provider "aws" {
  region = "us-west-2"
}
data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "eks-vpc"
  cidr = "10.0.0.0/16"

  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = 1
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.31"

  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["t3.micro"]
  }

  eks_managed_node_groups = {
    main = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = ["t3.micro"]
      capacity_type  = "SPOT"
    }
  }

  enable_cluster_creator_admin_permissions = true



  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

resource "helm_release" "hospital_app" {
  name             = "hospital-app"
  chart            = "../helm/hospital-chart"
  namespace        = "default"
  create_namespace = true

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

  depends_on = [module.eks]
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

  depends_on = [module.eks]
}

resource "kubectl_manifest" "argocd_application" {
  yaml_body = file("${path.module}/application.yaml")

  depends_on = [helm_release.argocd]
}