from airflow import DAG
from airflow.providers.google.cloud.sensors.gcs import (
    GCSObjectsWithPrefixExistenceSensor,
)
from airflow.operators.python import PythonOperator
from loader import load_content
from get_last_date import read_lastest_load_date
import datetime

with DAG(
    dag_id="load_movies",
    start_date=datetime.datetime(2024, 9, 10),
    schedule=None,
) as dag:
    gcs_file_sensor = GCSObjectsWithPrefixExistenceSensor(
        task_id='gcs_file_sensor',
        bucket="se-data-landing-subhajit",
        prefix='movies_', 
        timeout=30,
        soft_fail='true')
    
    lastest_load_date = PythonOperator(
        task_id='read_lastest_load_date',
        provide_context=True,
        python_callable=read_lastest_load_date)
    
    load_content_to_bucket = PythonOperator(task_id="load_content_to_bucket", python_callable=load_content, provide_context=True)
    
    [gcs_file_sensor,lastest_load_date] >> load_content_to_bucket