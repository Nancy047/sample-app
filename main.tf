
# Configure the Google Cloud Provider
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  credentials = file("keys.json")
  project     = "abc"
}

# Example resource configuration for Bare Metal Solution
resource "google_compute_instance_from_template" "basic_instance" {
  name         = "basic-instance"
  zone         = "us-central1-a"
  machine_type = "n1-standard-1"
  can_ip_forward = false
  network_interface {
    subnetwork = "projects/gcp-project-id/regions/us-central1/subnetworks/default"
  }
  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }
  network_performance_config {
    total_egress_bandwidth_tier = "DEFAULT"
  }
  confidential_instance_config {
    enable_confidential_compute = false
  }
  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }
  metadata {
    "startup-script" = <<EOF
#!/bin/bash
echo "Hello from a Bare Metal Solution instance!"
EOF
  }
}
