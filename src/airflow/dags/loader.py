from google.cloud import bigquery
import re
import datetime
import logging

def load_content(**kwargs):
        ti = kwargs['ti']
        files = ti.xcom_pull(task_ids="gcs_file_sensor", key="return_value")
        latest_load_date = ti.xcom_pull(task_ids="read_lastest_load_date", key="return_value")
        bucket = "se-data-landing-subhajit"
        for name in files:
            fileDate = extract_file_date(name)
            if(fileDate > latest_load_date):
                uri = f"gs://{bucket}/{name}"
                logging.info("Loading file: %s", uri)
                table_id = "ee-india-se-data.movies_data_subhajit."
                if name.startswith("movies"):
                    table_id += "movies_raw"
                elif name.startswith("ratings"):
                    table_id += "ratings_raw"
                load_from_uri(uri, table_id)
            else:
                logging.info("Won't load file: %s as the last load date is %s", name, latest_load_date)

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

def extract_file_date(filename):
    pattern = r'movies_(\d{4})(\d{2})(\d{2})' \
              r'(\d{2})_(\d{2})_(\d{2})\.csv'
    match = re.match(pattern, filename)
    if match:
        year, month, day, hour, minute, second = match.groups()
        dt = datetime.datetime(year=int(year), month=int(month), day=int(day),
                      hour=int(hour), minute=int(minute), second=int(second))
        return dt