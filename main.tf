terraform {
    required_providers {
      google  = {
        souce  = "hashcorp/google"
        version  = "~>4.37.0"
      }
    }
}

provider "google" {
    project = var.gcp_project_id
}

# Google Kubeneretes Engine (GKE)
resource "google_container_cluster" "primary" {
    name = "kubernetes-warm-up-01"
    location = var.gcp_region
    initial_node_count = 1
    enable_autopilot = true
    ip_allocation_policy {
      
    }
}

# CLOUD SQL
resource "google_sql_database_instance" {
    name = "cloudwarmupsql"
    region = var.gcp_region
    database_version = "MYSQL_8_0"
    settings {
      tier = "db-f1-micro"
    }
    deletion_protection = "true"
}

resource "google_sql_database" "database" {
  name = "mydatabase"
  instance = google_sql_database_instance.instance.name
}
