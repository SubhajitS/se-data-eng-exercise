variable "function" {
  type = object({
    name               = string
    location           = string
    description        = string
    runtime            = string
    entry_point        = string
    max_instance_count = number
    available_memory   = number
    timeout_seconds    = number
    trigger_http       = bool
    deploy = object({
      type        = string
      name        = string
      output_path = string
      source_dir  = string
    })
    storage = object({
      name                        = string
      uniform_bucket_level_access = bool
      force_destroy               = bool
      public_access_prevention    = string
      storage_class               = string
    })
  })
}
