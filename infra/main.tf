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

module "storage_bucket" {
  source = "./modules/storage"
  storage_bucket = {
    name                        = var.storage_bucket.name
    location                    = var.location
    storage_class               = var.storage_bucket.storage_class
    public_access_prevention    = var.storage_bucket.public_access_prevention
    uniform_bucket_level_access = var.storage_bucket.uniform_bucket_level_access
    force_destroy               = var.storage_bucket.force_destroy
  }
}

module "bigquery_datatable" {
  source = "./modules/datatable"
  dataset = {
    name                       = var.dataset.name
    location                   = var.location
    description                = var.dataset.description
    delete_contents_on_destroy = var.dataset.delete_contents_on_destroy
    access                     = var.dataset.access
  }
  datatable = {
    name                = var.datatable.name
    deletion_protection = var.datatable.deletion_protection
    schema              = var.datatable.schema
  }
}
