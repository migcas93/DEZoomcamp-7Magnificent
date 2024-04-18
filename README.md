# DEZoomcamp-7Magnificent
This Data Pipeline project was created with Google Cloud infrastructure, Mage.Ai, Docker, and Terraform to get financial data about the NASDAQ's seven magnificent stocks information

## Description of the Problem

This project is meant to create a batch data pipeline to get the Volume, Adjusted Close price, and other information of the seven magnificent stocks of NASDAQ (Apple, Microsoft, Google, Amazon, NVIDIA, Meta, and Tesla). Link to dashboard -> https://lookerstudio.google.com/reporting/0f14991e-dfeb-48b5-97b6-6be105fb4947/page/f36wD

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
![image](https://github.com/migcas93/DEZoomcamp-7Magnificent/assets/82487681/66954aa7-5a93-40af-b6b1-3bc5f59c6291)

![image](https://github.com/migcas93/DEZoomcamp-7Magnificent/assets/82487681/ba8f4f43-7434-4386-91a1-9eb2f1f2d13f)

### Before start…
Please ensure that you have the following requirements:
-	A Google Cloud Platform account (you can use a free account with USD 300)
-	Feel comfortable with the command line
-	Python knowledge
-	Terraform installed in your machine.

## Let’s start!

### 1.	Setup your project in Google Cloud Platform:
Initiate a new project in Google Platform to allocate the following services:
o	Google Virtual Machine: With this service, we will create a virtual machine to run Mage.ai (using Docker)
o	Google Cloud Storage: We will use this service to store the .parquet files and subsequently we will consume and transform this data in our Mage.ai pipeline
o	Google Big Query: In this service, we will create a dataset with the required tables for our dashboard.

#### 1.1	Creating the Service account and getting the “manage keys”.

Once we have created our project, we need to create a service account that will help us to manage our infrastructure using Terraform. 

With the service account created, we have to get the “manage keys”  in .JSON format from our service account to manage the infrastructure and Mage.ai (Please refer to this video https://www.youtube.com/watch?v=Y2ux7gq3Z0o&ab_channel=DataSlinger)


#### 1.2	Initiating the infrastructure with Terraform.
Clone the repository https://github.com/migcas93/DEZoomcamp-7Magnificent in your local machine to get the “Terraform” files to provision your resources.
In the “Terraform” folder you will find the “main.tf” file with the provisioned resources for GCP.  The following resources were provisioned in this file.

o	Google Cloud Storage -> “google_storage_bucket”
o	Google Big Query -> “google_bigquery_dataset”
o	Google VM Engine -> “google_compute_instance”
In the “variables.tf” we send some additional configurations for each resource such as location, project name, and VM image, among others. 
In the “./Terraform/Keys” directory, store the “manage keys” from step 1.1 in order to send the credentials to Terraform and do any modifications in your infrastructure. 
IMPORTANT**
To send your credentials to Terraform you can either use the “credentials”  parameter and write the path of the keys.json file or create an environment variable with the path to the keys (the second option is highly recommended). In the example below the environment variable is created in Windows (syntax might change in each OS)

 ![image](https://github.com/migcas93/DEZoomcamp-7Magnificent/assets/82487681/b1aa2887-8edc-4e98-88a8-524dbcc6cf74)


When the keys are set go to the directory where “main.tf” is located and execute the following commands (in this order):
o	terraform init -> This command initializes Terraform in your directory.
o	terraform plan -> This command shows which resource allocation will be executed in your GCP project.
o	terraform apply -> This command deploys all the provisioned resources to the cloud. You can double-check if resources are correctly deployed in the Google Console (for example, go to Virtual Machines and you will see a new instance created)

With this, you’re set and ready in GCP to proceed and run the data pipeline!

### 2.	Installing Docker and Mage.ai 
In this section we will install Docker and Mage.ai within our virtual machine to deploy and orchestrate the data pipelines.

#### 2.1 Installing Docker within the Virtual Machine
Go to the Google Console and within the Virtual Machine instances you’ll find the “mage-ai-instance” virtual machine (this one was created through Terraform). Start this engine clicking in the 3 dots and then on “Start/Resume” option.

![image](https://github.com/migcas93/DEZoomcamp-7Magnificent/assets/82487681/5ceaa2da-d058-4599-b84a-f16d02dd0f2d)
 
Once the virtual machine is running, go to the “SSH” option and a pop-up will appear. You need to authorize the “SSH-In-Browser” and a console will appear (In this case we’re using an Ubuntu OS for this machine)


In the SSH console, we need to install Docker. To do that follow these steps:
1.	Clone the repo of this project https://github.com/migcas93/DEZoomcamp-7Magnificent in the virtual machine. Use cd DEZoomcamp-7Magnificent to move to the directory.
2.	Clone this repo with the command “sudo git clone https://github.com/MichaelShoemaker/DockerComposeInstall” (Credits to one of our instructors in the DE Zoomcamp Michael Shoemaker AKA the “Data Slinger”)
3.	Go to the new directory “./DockerComposeInstall” and execute the following commands:
o	sudo chmod +x InstallDocker -> This transforms the “InstallDocker” file into an executable file
o	./InstallDocker -> Executes the Docker installer

#### 2.2 Installing Mage.ai image in the Virtual Machine
Go back to the “DEZoomcamp-7Magnificent” directory and execute the following command to instance the Mage.ai project.
o	newgrp docker
o	sudo docker run -it -p 6789:6789 -v $(pwd):/home/src mageai/mageai /app/run_app.sh mage start mage_project
o	sudo docker update –restart always “container name”

Is important to run these commands in the “DEZoomcamp-7Magnificent” directory since all the file for the pipeline are ready in the ”mage_project” .
The last command ensures docker container always restarts in the same state every time we activate our virtual machine and run Mage.ai in port 6789.
IMPORTANT**
In GCP you need to enable the requests to port 6789, otherwise you won’t be able to see Mage.ai working. This configuration needs to be done in “Firewalls”. In the example below I created a policy to access port 6789 with IP ranges 0.0.0.0/0 and applied it to the virtual machine I created

![image](https://github.com/migcas93/DEZoomcamp-7Magnificent/assets/82487681/4d3bbf59-285a-4b75-9b49-d783fb0180e9)


Our project will require the Python library “yfinance” as part of the project’s dependency. Since the Docker image has a Python installation inside, we need to use “pip install yfinance” within the Docker image. To do this we use the following commands:
•	docker exec -it <First 3 characters of docker container or container’s name> /bin/bash  To find the container’s ID and name use “sudo docker ps”
•	pip install yfinance

![image](https://github.com/migcas93/DEZoomcamp-7Magnificent/assets/82487681/8500a949-43e5-4e8e-94fd-3d263d5396b3)


 
With this, we are ready to move to Mage.ai!

### 3.	Building the data pipeline in Mage.ai

Once you create the Mage.ai instance, copy the external IP of the running VM to access Mage.ai using the port 6789 we exposed in the previous step (Ex: 35.202.188.33:6789)

![image](https://github.com/migcas93/DEZoomcamp-7Magnificent/assets/82487681/508189c1-0f0b-45d4-a383-2fb338e2436a)

 

#### 3.1 Creating the pipeline object and setting requirements and keys.
In the Mage.ai instance go to “Pipelines” and create a new pipeline where we will add the Extraction, Loading and Transformation steps. We will create a “Standard (batch)” pipeline”
 
![image](https://github.com/migcas93/DEZoomcamp-7Magnificent/assets/82487681/0f1bea9a-cbd8-40c1-8e6a-2bf90fe6d73c)


On the left side, we require to update the files “requirements.txt” and “io_config.yaml” to let Mage.ai know we need the “yfinance” library and to get the manage keys we generated in section 1 to modify GCS and Google Big Query since we’re moving and consuming files in these 2 services.
For “requirements.txt” file, open the file and write “yfinance” to ensure Mage.ai gets this library in your project (see screenshots below)

For “io_config.yaml” use the “GOOGLE_SERVICE_ACC_KEY_FILEPATH” variable and enter the path where you have allocated the manage keys of your service account (in my case, I store the manage keys in the path “mage_project/keys/my-creds.json"

![image](https://github.com/migcas93/DEZoomcamp-7Magnificent/assets/82487681/44e29e37-c886-478d-9027-56df306a6c1d)

![image](https://github.com/migcas93/DEZoomcamp-7Magnificent/assets/82487681/7c52d7d5-0a2b-40a1-99bf-b5f03699d978)

![image](https://github.com/migcas93/DEZoomcamp-7Magnificent/assets/82487681/388a7484-08ae-4242-8d1b-f1187a272eb2)
  

#### 3.2 Creating Transformation blocks.

The "mage_project" and "mage_data" already contain all the files you need. However, In the “Transformation blocks.ipynb” file you’ll find the Extraction, Transformation, and Loading blocks for our project in case you want to recreate them from scratch.

You just need to copy the code for each block to run the pipeline.


For the data Extraction we will create a “Data Loader” block with a “Generic template”. Paste the code written in the first cell of the Jupyter Notebook (Is commented as “Data Loader Code”

![image](https://github.com/migcas93/DEZoomcamp-7Magnificent/assets/82487681/88833caf-ba1e-4ffa-9d59-d2dec8e476f6)

 
Then we need to create “Data Transformer” and “Data Exporter” blocks. Data Transformer will be a “Generic (no template” block and “Data Exporter” will be a “Google Big Query” and “Google Cloud Storage” block. The code for each block can be found in the Jupyter Notebook mentioned previously.

![image](https://github.com/migcas93/DEZoomcamp-7Magnificent/assets/82487681/bf388263-1b75-4bbd-b6c4-d28fa23eb75c)

 ![image](https://github.com/migcas93/DEZoomcamp-7Magnificent/assets/82487681/37936a01-4eff-41ca-b83f-105df050d444)

 
When your pipeline is ready, the blocks will look like this:

![image](https://github.com/migcas93/DEZoomcamp-7Magnificent/assets/82487681/023b82f4-377c-4fd2-a9c7-68ffe56ea579)

IMPORTANT**: On the "Data Exporter" blocks, you need to change the "table_id" variable for the name of your project in Google Cloud Platform ("project_name"."dataset_name"."table_name")
 
#### 3.3 Scheduling the Trigger to run data pipeline hourly.
In the data pipeline menu, look for a bar called “Triggers” where you can schedule the data pipeline running. For this use case, I scheduled the data pipeline trigger hourly as you can see in the example below.

 ![image](https://github.com/migcas93/DEZoomcamp-7Magnificent/assets/82487681/f54c2d05-796e-42dd-a43a-cd734888d15d)
![image](https://github.com/migcas93/DEZoomcamp-7Magnificent/assets/82487681/a0819fc1-0a7b-4667-8436-3342beb5a062)

 

BONUS!
In this use case, the stock market is open from 09:30 AM EDT to 4:00 PM EDT, you can use the “Instance Schedule” feature of the VM Engine to activate/deactivate the Virtual Machine at hours when you don’t need it to save resources (and money!).
