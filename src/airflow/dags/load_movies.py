from airflow import DAG
from airflow.operators.python import PythonOperator
from loader import load_content
from get_last_date import read_lastest_load_date
from read_files import read_latest_files_from_bucket
import datetime

with DAG(
    dag_id="load_movies",
    start_date=datetime.datetime(2024, 9, 10),
    schedule=None,
) as dag:
    lastest_load_date = PythonOperator(
        task_id='read_lastest_load_date',
        provide_context=True,
        python_callable=read_lastest_load_date
    )
    
    latest_files = PythonOperator(
        task_id='read_latest_files',
        provide_context=True,
        python_callable=read_latest_files_from_bucket
    )

    load_content_to_raw_layer = PythonOperator(task_id="load_content_to_raw_layer", python_callable=load_content, provide_context=True)
    
    lastest_load_date >> latest_files >> load_content_to_raw_layer