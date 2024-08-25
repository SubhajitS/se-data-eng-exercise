variable "dataset" {
  type = object({
    name                        = string
    location                    = string
    description                 = string
    delete_contents_on_destroy  = bool
  })
}

variable "datatable" {
  type = object({
    name                = string
    deletion_protection = bool
    schema              = string
  })
}
