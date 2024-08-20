module "storage_bucket" {
  source = "../storage"
  storage_bucket = {
    name = var.function.storage.name
    location = var.function.location
    uniform_bucket_level_access = var.function.storage.uniform_bucket_level_access
    force_destroy = var.function.storage.force_destroy
    public_access_prevention = var.function.storage.public_access_prevention
    storage_class = var.function.storage.storage_class
  }
}

data "archive_file" "default" {
  type        = var.function.deploy.type
  output_path = var.function.deploy.output_path
  source_dir  = var.function.deploy.source_dir
}

resource "google_storage_bucket_object" "object" {
  depends_on = [ module.storage_bucket, data.archive_file.default ]
  name   = var.function.deploy.name
  bucket = module.storage_bucket.storage_bucket_name
  source = data.archive_file.default.output_path
}

resource "google_cloudfunctions_function" "function" {
  depends_on = [ google_storage_bucket_object.object ]
  name        = var.function.name
  description = var.function.description
  runtime = var.function.runtime
  region = var.function.location

  available_memory_mb = var.function.available_memory
  source_archive_bucket = module.storage_bucket.storage_bucket_name
  source_archive_object = google_storage_bucket_object.object.name
  entry_point = var.function.entry_point
  event_trigger {
    event_type = var.function.event_type
    resource = var.function.event_source
  }
}
