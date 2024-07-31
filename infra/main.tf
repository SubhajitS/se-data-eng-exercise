terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  project = var.project
}

resource "google_storage_bucket" "se-data-storage-bucket" {
  name                        = var.storage_bucket.name
  location                    = var.location
  storage_class               = var.storage_bucket.storage_class
  force_destroy               = var.storage_bucket.force_destroy
  public_access_prevention    = var.storage_bucket.public_access_prevention
  uniform_bucket_level_access = var.storage_bucket.uniform_bucket_level_access
}

resource "google_bigquery_dataset" "se-data-dataset" {
  dataset_id  = var.dataset.name
  location    = var.location
  description = var.dataset.description
  delete_contents_on_destroy = var.dataset.delete_contents_on_destroy

  access {
    role          = var.dataset.access.role
    user_by_email = var.dataset.access.email
  }
}

resource "google_bigquery_table" "se-data-raw-table" {
  depends_on = [ google_bigquery_dataset.se-data-dataset ]
  dataset_id = google_bigquery_dataset.se-data-dataset.dataset_id
  table_id   = var.datatable.name
  deletion_protection = var.datatable.deletion_protection
  schema     = var.datatable.schema
}
