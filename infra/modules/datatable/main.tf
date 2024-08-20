resource "google_bigquery_dataset" "se-data-dataset" {
  dataset_id  = var.dataset.name
  location    = var.dataset.location
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

resource "google_bigquery_dataset_iam_binding" "dataEditor" {
  dataset_id = google_bigquery_dataset.se-data-dataset.dataset_id
  role       = "roles/bigquery.dataEditor"

  members = [
    var.dataset.data_editor_service_account
  ]
}