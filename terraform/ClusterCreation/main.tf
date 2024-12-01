# main.tf for GKE Cluster Creation

data "google_compute_default_service_account" "default" {
  project = var.project_id
}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 7.0"

  project_id   = var.project_id
  network_name = "${var.cluster_name}-vpc"
  routing_mode = "GLOBAL"

  delete_default_internet_gateway_routes = false

  subnets = [
    {
      subnet_name           = "${var.cluster_name}-subnet"
      subnet_ip             = "10.0.0.0/16"
      subnet_region         = var.region
      subnet_private_access = true
    },
  ]

  secondary_ranges = {
    "${var.cluster_name}-subnet" = [
      {
        range_name    = var.ip_range_pods_name
        ip_cidr_range = "192.168.0.0/18"
      },
      {
        range_name    = var.ip_range_services_name
        ip_cidr_range = "192.168.64.0/18"
      },
    ]
  }

  routes = [
    {
      name              = "egress-internet"
      description       = "Route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      next_hop_internet = "true"
    }
  ]

  firewall_rules = [
    {
      name        = "allow-internal"
      description = "Allow internal traffic"
      direction   = "INGRESS"
      ranges      = ["10.0.0.0/16", "192.168.0.0/18", "192.168.64.0/18"]
      allow = [{
        protocol = "tcp"
        ports    = ["0-65535"]
        },
        {
          protocol = "udp"
          ports    = ["0-65535"]
        },
        {
          protocol = "icmp"
      }]
    }
  ]
}

module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  version                    = "~> 23.0"
  project_id                 = var.project_id
  name                       = var.cluster_name
  region                     = var.region
  zones                      = ["${var.region}-a", "${var.region}-b", "${var.region}-c"]
  network                    = module.vpc.network_name
  subnetwork                 = module.vpc.subnets_names[0]
  ip_range_pods              = var.ip_range_pods_name
  ip_range_services          = var.ip_range_services_name
  http_load_balancing        = false
  network_policy             = false
  horizontal_pod_autoscaling = true
  filestore_csi_driver       = false

  node_pools = [
    {
      name               = "default-node-pool"
      machine_type       = "e2-medium"
      min_count          = 1
      max_count          = 3
      local_ssd_count    = 0
      disk_size_gb       = 100
      disk_type          = "pd-standard"
      image_type         = "COS_CONTAINERD"
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = false
      initial_node_count = 2
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}

resource "google_project_iam_member" "kubernetes_engine_admin" {
  project = var.project_id
  role    = "roles/container.admin"
  member  = "serviceAccount:${data.google_compute_default_service_account.default.email}"
}

