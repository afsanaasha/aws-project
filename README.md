# aws-project

Data Source: http://deepyeti.ucsd.edu/jianmo/amazon/

Category choosen: Magagize Subscription

Checkpoint#1:
Objectives:
1. Load into the Cloud either product JSON (called "metadata" on the source github) or review JSON from at least one category of Amazon data.
2. Perform one or more queries over your data set in the cloud.



Approach:
Step 1: amazon-review-json-to-csv.ipynb
        To convert JSON data (Magagine_Subscription.json) to CSV in Local Jupyter Notebook
        
Step 2: AWS S3: Magagine_Subscription.csv
        Upload the CSV file from local to AWS S3 bucket
        
Step 3: AWS Sagemaker: Checkpoint_1.ipynb
        Load S3 data in AWS Sagemaker Studio Notebook using boto3 library
