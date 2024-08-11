variable "storage_bucket" {
  type = object({
    name                        = string
    location                    = string
    storage_class               = string
    public_access_prevention    = string
    uniform_bucket_level_access = bool
    force_destroy               = bool
  })
}