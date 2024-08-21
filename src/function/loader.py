from google.cloud import bigquery

def load_from_uri(uri):
    client = bigquery.Client()

    table_id = "ee-india-se-data.movies_data_subhajit.movies_raw"

    job_config = bigquery.LoadJobConfig(
        allow_jagged_rows=True,
        skip_leading_rows=1,        
        source_format=bigquery.SourceFormat.CSV,
    )

    load_job = client.load_table_from_uri(
        uri, table_id, job_config=job_config
    ) 

    load_job.result()

    print("Loaded {} rows.".format(load_job.output_rows))