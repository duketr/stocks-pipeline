#!/bin/bash

# Create project directory structure
echo "Creating project directories..."

# Airflow directories
mkdir -p dags
mkdir -p logs
mkdir -p plugins

# Spark directories
mkdir -p spark-apps
mkdir -p spark-data

# Kafka directories
mkdir -p kafka-config

# Data directories
mkdir -p data/raw
mkdir -p data/processed

# Create a sample Airflow DAG
cat > dags/sample_dag.py << 'EOF'
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
EOF

# Create a sample Spark application
cat > spark-apps/sample_spark_app.py << 'EOF'
from pyspark.sql import SparkSession

def main():
    spark = SparkSession.builder \
        .appName("SampleSparkApp") \
        .getOrCreate()
    
    # Sample data
    data = [
        ("Alice", 25, "Engineer"),
        ("Bob", 30, "Data Scientist"),
        ("Charlie", 35, "Manager")
    ]
    
    columns = ["name", "age", "role"]
    
    df = spark.createDataFrame(data, columns)
    
    print("Sample DataFrame:")
    df.show()
    
    print("DataFrame Schema:")
    df.printSchema()
    
    spark.stop()

if __name__ == "__main__":
    main()
EOF

# Create .env file for environment variables
cat > .env << 'EOF'
# MinIO
MINIO_ROOT_USER=minioadmin
MINIO_ROOT_PASSWORD=minioadmin

# Airflow
AIRFLOW_UID=50000
AIRFLOW_GID=50000

# Postgres
POSTGRES_USER=airflow
POSTGRES_PASSWORD=airflow
POSTGRES_DB=airflow

# Kafka
KAFKA_BROKER_ID=1
EOF

# Create README
cat > README.md << 'EOF'
# Data Engineering Platform with Docker

This project sets up a complete data engineering platform using Docker Compose with the following components:

- **Apache Spark**: Distributed data processing
- **Apache Airflow**: Workflow orchestration
- **Apache Kafka**: Event streaming
- **MinIO**: S3-compatible object storage

## Quick Start

1. Start all services:
   ```bash
   docker-compose up -d
   ```

2. Access the services:
   - Airflow Web UI: http://localhost:8080 (admin/admin)
   - Spark Master UI: http://localhost:8081
   - MinIO Console: http://localhost:9001 (minioadmin/minioadmin)
   - Kafka: localhost:9092

3. Stop all services:
   ```bash
   docker-compose down
   ```

## Directory Structure

- `dags/`: Airflow DAG definitions
- `spark-apps/`: Spark applications
- `data/`: Data storage (raw and processed)
- `logs/`: Application logs
- `plugins/`: Airflow plugins

## Testing Components

### Test Spark
```bash
docker exec -it spark-master spark-submit /opt/spark-apps/sample_spark_app.py
```

### Test Kafka
```bash
# Create a topic
docker exec -it kafka kafka-topics.sh --create --topic test-topic --bootstrap-server localhost:9092

# List topics
docker exec -it kafka kafka-topics.sh --list --bootstrap-server localhost:9092
```

### Test MinIO
Access the MinIO console at http://localhost:9001 and create buckets for data storage.

### Test Airflow
Access the Airflow UI at http://localhost:8080 and trigger the sample DAG.
EOF

echo "Project setup complete!"
echo ""
echo "Next steps:"
echo "1. Review the docker-compose.yml file"
echo "2. Run: docker-compose up -d"
echo "3. Access services at:"
echo "   - Airflow: http://localhost:8080 (admin/admin)"
echo "   - Spark Master: http://localhost:8081"
echo "   - MinIO: http://localhost:9001 (minioadmin/minioadmin)"
echo "   - Kafka: localhost:9092"