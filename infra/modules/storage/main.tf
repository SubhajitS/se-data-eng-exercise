resource "google_storage_bucket" "se-data-storage-bucket" {
  name                        = var.storage_bucket.name
  location                    = var.storage_bucket.location
  storage_class               = var.storage_bucket.storage_class
  force_destroy               = var.storage_bucket.force_destroy
  public_access_prevention    = var.storage_bucket.public_access_prevention
  uniform_bucket_level_access = var.storage_bucket.uniform_bucket_level_access
}