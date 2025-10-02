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
