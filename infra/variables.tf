variable "project" {
  type    = string
  default = "ee-india-se-data"
}
variable "location" {
  type    = string
  default = "ASIA-SOUTH1"
}
variable "region" {
  type    = string
  default = "asia-south1"
}
variable "storage_bucket" {
  type = object({
    name                        = string
    storage_class               = string
    public_access_prevention    = string
    uniform_bucket_level_access = bool
    force_destroy               = bool
  })
  default = {
    name                        = "se-data-landing-subhajit"
    storage_class               = "STANDARD"
    public_access_prevention    = "enforced"
    force_destroy               = true
    uniform_bucket_level_access = true
  }
}

variable "dataset" {
  type = object({
    name                       = string
    description                = string
    delete_contents_on_destroy = bool
  })
  default = {
    name                       = "movies_data_subhajit"
    description                = "This is a test dataset"
    delete_contents_on_destroy = true
  }
}

variable "datatable" {
  type = list(object({
    name                = string
    deletion_protection = bool
    schema              = string
  }))
  default = [{
    name                = "movies_raw"
    deletion_protection = false
    schema              = <<EOF
  [
    {
      "name":"adult",
      "type":"STRING",
      "mode":"NULLABLE",
      "description":""
    },
    {
      "name":"belongs_to_collection",
      "type":"STRING",
      "mode":"NULLABLE",
      "description":""
    },
    {
      "name":"budget",
      "type":"STRING",
      "mode":"NULLABLE",
      "description":""
    },
    {
      "name":"genres",
      "type":"STRING",
      "mode":"NULLABLE",
      "description":""
    },
    {
      "name":"homepage",
      "type":"STRING",
      "mode":"NULLABLE",
      "description":""
    },
    {
      "name":"id",
      "type":"STRING",
      "mode":"NULLABLE",
      "description":""
    },
    {
      "name":"imdb_id",
      "type":"STRING",
      "mode":"NULLABLE",
      "description":""
    },
    {
      "name":"original_language",
      "type":"STRING",
      "mode":"NULLABLE",
      "description":""
    },
    {
      "name":"original_title",
      "type":"STRING",
      "mode":"NULLABLE",
      "description":""
    },
    {
      "name":"overview",
      "type":"STRING",
      "mode":"NULLABLE",
      "description":""
    },
    {
      "name":"popularity",
      "type":"STRING",
      "mode":"NULLABLE",
      "description":""
    },
    {
      "name":"poster_path",
      "type":"STRING",
      "mode":"NULLABLE",
      "description":""
    },
    {
      "name":"production_companies",
      "type":"STRING",
      "mode":"NULLABLE",
      "description":""
    },
    {
      "name":"production_countries",
      "type":"STRING",
      "mode":"NULLABLE",
      "description":""
    },
    {
      "name":"release_date",
      "type":"STRING",
      "mode":"NULLABLE",
      "description":""
    },
    {
      "name":"revenue",
      "type":"STRING",
      "mode":"NULLABLE",
      "description":""
    },
    {
      "name":"runtime",
      "type":"STRING",
      "mode":"NULLABLE",
      "description":""
    },
    {
      "name":"spoken_languages",
      "type":"STRING",
      "mode":"NULLABLE",
      "description":""
    },
    {
      "name":"status",
      "type":"STRING",
      "mode":"NULLABLE",
      "description":""
    },
    {
      "name":"tagline",
      "type":"STRING",
      "mode":"NULLABLE",
      "description":""
    },
    {
      "name":"title",
      "type":"STRING",
      "mode":"NULLABLE",
      "description":""
    },
    {
      "name":"video",
      "type":"STRING",
      "mode":"NULLABLE",
      "description":""
    },
    {
      "name":"vote_average",
      "type":"STRING",
      "mode":"NULLABLE",
      "description":""
    },
    {
      "name":"vote_count",
      "type":"STRING",
      "mode":"NULLABLE",
      "description":""
    },
    {
      "name":"load_date",
      "type":"DATETIME",
      "mode":"NULLABLE",
      "description":"",
      "defaultValueExpression":"CURRENT_DATETIME"
    }
  ]
  EOF
  },
  {
    name                = "ratings_raw"
    deletion_protection = false
    schema              = <<EOF
    [
      {
        "name":"userId",
        "type":"STRING",
        "mode":"NULLABLE",
        "description":""
      },
      {
        "name":"movieId",
        "type":"STRING",
        "mode":"NULLABLE",
        "description":""
      },
      {
        "name":"rating",
        "type":"STRING",
        "mode":"NULLABLE",
        "description":""
      },
      {
        "name":"timestamp",
        "type":"STRING",
        "mode":"NULLABLE",
        "description":""
      }
    ]
    EOF
  }]
}

variable "function" {
  type = object({
    name                                = string
    description                         = string
    runtime                             = string
    entry_point                         = string
    available_memory                    = number
    max_instance_count                  = number
    timeout_seconds                     = number
    artifact_type                       = string
    artifact_name                       = string
    source_dir                          = string
    output_path                         = string
    storage_name                        = string
    storage_class                       = string
    storage_public_access_prevention    = string
    storage_force_destroy               = bool
    storage_uniform_bucket_level_access = bool
    event_type                          = string
  })
  default = {
    name                                = "se-data-loader-subhajit"
    description                         = "a new function"
    runtime                             = "python39"
    entry_point                         = "load_file"
    available_memory                    = 128
    max_instance_count                  = 1
    timeout_seconds                     = 60
    artifact_type                       = "zip"
    artifact_name                       = "function-source.zip"
    source_dir                          = "../src/function"
    output_path                         = "/tmp/function-source.zip"
    storage_name                        = "se-data-function-subhajit"
    storage_class                       = "STANDARD"
    storage_public_access_prevention    = "enforced"
    storage_force_destroy               = true
    storage_uniform_bucket_level_access = true
    event_type                          = "google.storage.object.finalize"
  }
}
