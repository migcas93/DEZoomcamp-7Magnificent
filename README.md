# DEZoomcamp-7Magnificent
This Data Pipeline project was created with Google Cloud infrastructure, Mage.Ai, Docker, and Terraform to get financial data about the NASDAQ's seven magnificent stocks information

## Description of the Problem

This project is meant to create a batch data pipeline to get the Volume, Adjusted Close price and other information of the seven magnificent stocks of NASDAQ (Apple, Microsoft, Google, Amazon, NVIDIA, Meta, and Tesla).

This data will be obtained from the Yahoo Finance API (YFinance) and uploaded to Google Cloud Storage in .parquet format followed by a transformation performed using a Transformer block within Mage.ai pipeline to create the desired tables in Google Big Query and consume this data in Looker Studio. 
All the GCP infrastructure is set using Terraform as IaC and Mage.ai will run in a Google Virtual Machine and Docker.

### Tools & Technologies

-	Cloud Provider: Google Cloud Platform
-	Infrastructure as Code (IaC): Terraform
-	Containerization: Docker
-	Batch Processing & Orchestration: Mage.ai
-	Transformation: Mage.ai
-	Data Lake: Google Cloud Storage
-	Data Warehouse: Google Big Query
-	Data Visualization: Google Locker
-	Languages: Python & SQL

### Architecture & Final Result
