from airflow.providers.google.cloud.hooks.bigquery import BigQueryHook

def read_lastest_load_date(**kwargs):
    sql="SELECT MAX(load_date) AS lastest_load_date FROM `ee-india-se-data.movies_data_subhajit.movies_raw`"
    hook = BigQueryHook()
    client = hook.get_client(project_id="ee-india-se-data")
    # instead directly create a client using the internals of the hook:
    #client = bigquery.Client(project=hook._get_field("project"), credentials=hook._get_credentials())
    query_job = client.query(sql)
    for row in query_job:
        return row["lastest_load_date"]