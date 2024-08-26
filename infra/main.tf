terraform {
  backend "gcs" {
    bucket  = "tf-state-se-data-subhajit"
    prefix  = "terraform/state"
  }
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
  }
  datatable = var.datatable
}

module "function" {
  source = "./modules/function"
  function = {
    name               = var.function.name
    description        = var.function.description
    runtime            = var.function.runtime
    location           = var.region
    entry_point        = var.function.entry_point
    available_memory   = var.function.available_memory
    max_instance_count = var.function.max_instance_count
    timeout_seconds    = var.function.timeout_seconds
    event_type         = var.function.event_type
    event_source       = module.storage_bucket.storage_bucket_name
    deploy = {
      name        = var.function.artifact_name
      type        = var.function.artifact_type
      source_dir  = var.function.source_dir
      output_path = var.function.output_path
    }
    storage = {
      name                        = var.function.storage_name
      force_destroy               = var.function.storage_force_destroy
      public_access_prevention    = var.function.storage_public_access_prevention
      storage_class               = var.function.storage_class
      uniform_bucket_level_access = var.function.storage_uniform_bucket_level_access
    }
  }
}
