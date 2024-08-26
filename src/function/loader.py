from google.cloud import bigquery

def load_from_uri(uri):
    client = bigquery.Client()

    table_id = "ee-india-se-data.movies_data_subhajit.movies_raw"

    job_config = load_job_config(table_id)

    load_job = client.load_table_from_uri(
        uri, table_id, job_config=job_config
    ) 

    load_job.result()

    print("Loaded {} rows.".format(load_job.output_rows))

def load_job_config(client, table_id):
    job_config = bigquery.LoadJobConfig(
        schema=derive_schema(client, table_id),
        skip_leading_rows=1,        
        source_format=bigquery.SourceFormat.CSV,
        write_disposition=bigquery.WriteDisposition.WRITE_APPEND
    )
    return job_config

def derive_schema(client, table_id):
    schema = []
    for schema_field in client.get_table(table_id).schema:
        if schema_field.name != "load_date":
            schema.append(bigquery.SchemaField(name=schema_field.name, field_type=schema_field.field_type, mode=schema_field.mode))
    return schema