from google.cloud import bigquery
import logging

def load_content(**kwargs):
        ti = kwargs['ti']
        files = ti.xcom_pull(task_ids="read_latest_files", key="return_value")
        bucket = "se-data-landing-subhajit"
        for name in files:
            uri = f"gs://{bucket}/{name}"
            logging.info("Loading file: %s", uri)
            table_id = "ee-india-se-data.movies_data_subhajit."
            if name.startswith("movies"):
                table_id += "movies_raw"
            elif name.startswith("ratings"):
                table_id += "ratings_raw"
            load_from_uri(uri, table_id)
            

def load_from_uri(uri, table_id):
    client = bigquery.Client()

    job_config = load_job_config(client, table_id)

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
