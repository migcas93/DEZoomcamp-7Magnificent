terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.23.0"
    }
  }
}

provider "google" {
  # To initialize the credentials use $env:GOOGLE_APPLICATION_CREDENTIALS= "./my-creds.json"
  
  project = var.project
  region  = "us-central1"
}

resource "google_storage_bucket" "demo-bucket" {
  name          = var.gcs_bucket_name
  location      = "US"
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

resource "google_bigquery_dataset" "demo_dataset" {
  dataset_id = var.bq_dataset_name
  location   = var.location
}

resource "google_compute_instance" "mage-ai-instance" {
  name = "mage-ai-instance"
  machine_type = "e2-standard-4"
  zone = "us-central1-a"
  tags = ["mage-ai"]
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = var.vm_image
      size  = 10
    }
  }

  network_interface {
    network = var.network
    access_config {
    }
  }
}

