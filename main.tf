
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

# Google Kubernetes Engine (Basic)
resource "google_container_cluster" "basic_cluster" {
  name               = "basic-cluster"
  location           = "us-central1"
  initial_node_count = 1
  node_config {
    machine_type = "e2-small"
  }
  network            = "default"
}

# Google Cloud Functions (Basic)
resource "google_cloudfunctions_function" "basic_function" {
  name        = "basic-function"
  runtime     = "nodejs16"
  entry_point = "helloHTTP"
  source_archive_bucket = "your-bucket-name"
  source_archive_object = "your-function-code.zip"
  trigger_http = true
  timeout     = 60
  available_memory_mb = 128
}

# App Engine (Basic)
resource "google_app_engine_application" "basic_app" {
  location_id = "us-central"
  project     = "lumen-b-ctl"
}

resource "google_app_engine_standard_app_version" "basic_service" {
  service   = "basic-service"
  project   = "lumen-b-ctl"
  runtime   = "nodejs16"
  version_id = "v1"
  entrypoint {
    shell = "node app.js"
  }
  deployment {
    zip {
      source_url = "gs://lumen-b-ctl/app.zip"
    }
  }
  manual_scaling {
    instances = 1
  }
}
