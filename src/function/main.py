import functions_framework

from google.cloud import bigquery

@functions_framework.cloud_event
def load_file(cloud_event):
    data = cloud_event.data
    print(data)
    client = bigquery.Client()

    table_id = "ee-india-se-data.movies_data_subhajit.movies_raw"

    job_config = bigquery.LoadJobConfig(
        allow_jagged_rows=True,
        skip_leading_rows=1,        
        source_format=bigquery.SourceFormat.CSV,
    )
    bucket = data["bucket"]
    name = data["name"]
    uri = f"gs://{bucket}/{name}"
    print(uri)

    load_job = client.load_table_from_uri(
        uri, table_id, job_config=job_config
    ) 

    load_job.result()

    destination_table = client.get_table(table_id)
    print("Loaded {} rows.".format(destination_table.num_rows))