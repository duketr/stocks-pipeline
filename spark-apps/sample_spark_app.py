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
