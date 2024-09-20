from airflow.providers.google.cloud.hooks.gcs import GCSHook
from datetime import datetime, timezone

def read_latest_files_from_bucket(**kwargs):
    ti = kwargs['ti']
    latest_load_date = ti.xcom_pull(task_ids="read_lastest_load_date", key="return_value")
    gcsHook = GCSHook()
    newFiles = gcsHook.list_by_timespan("se-data-landing-subhajit", latest_load_date.replace(tzinfo=timezone.utc), datetime.now(timezone.utc), prefix="movies_", match_glob='*.csv')
    print("Read_file_from_storage: Found {} new files".format(len(newFiles)))
    return newFiles