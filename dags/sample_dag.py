from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator

default_args = {
    'owner': 'data-engineer',
    'depends_on_past': False,
    'start_date': datetime(2024, 1, 1),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5)
}

dag = DAG(
    'sample_data_pipeline',
    default_args=default_args,
    description='Sample data pipeline',
    schedule_interval=timedelta(days=1),
    catchup=False
)

def print_hello():
    return 'Hello from Airflow!'

hello_task = PythonOperator(
    task_id='hello_task',
    python_callable=print_hello,
    dag=dag
)

spark_task = BashOperator(
    task_id='spark_task',
    bash_command='echo "Spark job would run here"',
    dag=dag
)

hello_task >> spark_task
