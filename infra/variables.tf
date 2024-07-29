variable "project" {
    type = string
    default = "ee-india-se-data"
}
variable "storage_bucket" {
    type = object({
      name = string
      location = string
      storage_class = string
      public_access_prevention = string
      uniform_bucket_level_access = bool
      force_destroy = bool
    })
    default = {
      name = "se-data-landing-subhajit"
      location = "ASIA-SOUTH1"
      storage_class = "STANDARD"
      public_access_prevention = "enforced"
      force_destroy = true
      uniform_bucket_level_access = true
    }
}