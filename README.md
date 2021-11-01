# cloud-project

Data Source: http://deepyeti.ucsd.edu/jianmo/amazon/

Category choosen: Magagize Subscription

Checkpoint#1:
Objectives:
1. Load into the Cloud either product JSON (called "metadata" on the source github) or review JSON from at least one category of Amazon data.
2. Perform one or more queries over your data set in the cloud.



AWS Approach:

1) AWS Glue + Athena Solution

Step 1: S3: Magazine_Subscription.json
            Upload the JSON data in AWS S3 bucket
Step 2: AWS Glue: aws_glue_pyspark_flatten_json.ipynb
        Create and run Crawler to add Database and Table
        Create IAM AWSGlueServiceRole and attach AmazonS3FullAcessPolicy to the role
        Create Devendpoint using the IAM Role
        Create Pyspark Notebook using the devendpoint
        Execute the codes and save the flatten output data in S3 bucket
Step 3: AWS Athena: aws_atherna_queries_checkpoint1.sql
        Manage the settings to save the output queries in S3
        In query editor create the schema using the database in AWSGlueCatalog
        Perform select queries
        
        

2) Sagemaker Solution

Step 1: amazon-review-json-to-csv.ipynb
        To convert JSON data (Magazine_Subscription.json) to CSV in Local Jupyter Notebook
        
Step 2: S3: Magagine_Subscription.csv
        Upload the CSV file from local to AWS S3 bucket
        
Step 3: AWS Sagemaker: Checkpoint_1.ipynb
        Load S3 data in AWS Sagemaker Studio Notebook using boto3 and io library
        
        
        
GCP Approach:
