provider "google" {
  project = "neon-effect-459412-p7"
  region  = "us-central1"
}

resource "google_container_cluster" "primary" {
  name     = "gke-cluster-autoscale-tc"
  location = "us-central1"

  remove_default_node_pool = true
  initial_node_count       = 1

  deletion_protection = false

  networking_mode = "VPC_NATIVE" 
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-node-pool"
  location   = "us-central1"
  cluster    = google_container_cluster.primary.name
  node_count = 2

  autoscaling {
    min_node_count = 2
    max_node_count = 3
  }
node_config {
  machine_type = "e2-medium"
  disk_type    = "pd-standard"  
  disk_size_gb = 30             

  oauth_scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
  ]
}

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}