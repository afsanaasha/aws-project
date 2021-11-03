# cloud-project

Checkpoint#1
DSBA 6190 Checkpoint #1 Student Name: Afsana Akther Asha

Data Source: http://deepyeti.ucsd.edu/jianmo/amazon/

Category choosen: Magagize Subscription

Objective 1. Load into the Cloud either product JSON (called &quot;metadata&quot; on the source github) or review JSON from at least one category of Amazon data.

**Step 1:** Upload the amazon JSON data in S3 bucket.

I chose review data for &quot;Magazine\_Subscriptions.json&quot; and my bucket path is s3://afsana where I loaded the json data

(![image](https://user-images.githubusercontent.com/73313035/140012138-3acce59c-8031-493a-a19e-4c5c4e0b70c5.png)

**Step 2:** Create a crawler in AWS Glue.

Go to AWS Glue console. Glue is an ETL service where we will use crawler to create table. From the Data Catalog section click on &quot;Crawlers&quot;. This will take into a page that says &quot;you do not have any crawlers yet&quot;. Click on &quot;Add a crawler&quot;.

![](RackMultipart20211103-4-zdfe80_html_4664ba901287d819.png) ![](RackMultipart20211103-4-zdfe80_html_28149a588e32f8d.png)

Give it a name in the Crawler name field. I named it as &quot;review\_crawler&quot;. Extending the arrow, we can also provide tag, description and security configuration. Tags will help us to categorized resources. Since they are optional, I kept this section empty.

![](RackMultipart20211103-4-zdfe80_html_e4a7461ac2aae556.png)

Click Next. We need to specify the crawler source type. I used the default source type which is &quot;Data stores&quot;. But we can use existing catalog tables as well.

![](RackMultipart20211103-4-zdfe80_html_be110ddd517ad8b3.png)

We can add the datastore from S3, DynaboDB or JDBC connection type. I chose &quot;S3&quot; as my datastore since my data is in S3.

![](RackMultipart20211103-4-zdfe80_html_a3ea310d4592a748.png)

After that need to include the S3 path. Click on the file icon beside &quot;Include path&quot; field. I need to crawl &quot;s3://afsana/Magagize\_Subscriptions.json&quot; only, therefore I only selected that. If we need to crawl all data in a particular folder, we can choose that folder in the bucket as well. Click &quot;Select&quot;. Then we can use the optional &quot;Exclude path&quot; option to exclude any subfolder (for instance, in this case athena-output) in the s3://afsana that we do not want to scan and crawl to create table name and definitions. If mentioned log/\*\* it will skip all the subfolders inside the logs if we have any. I kept it empty as I only chose a particular data file. Click &quot;Next&quot;.

![](RackMultipart20211103-4-zdfe80_html_fb9764ef48f1b1fd.png)

It will ask if we want to add another datastore. I selected &quot;No&quot;. Click &quot;Next&quot;.

![](RackMultipart20211103-4-zdfe80_html_66c660b87b134c8.png)

This will bring us to an important step asking us to choose an IAM role. We need to have S3 read permission to read the data. We can provide Athena GetObject action to S3 and Glue. For Glue this is necessary because the crawler need to scan and fetch the meta data information after reading the file. For Athena it is also required to access the folder for which we will be running queries. If we have already created IAM role it will let us choose from the existing IAM roles. As I do not have any, I created an IAM role as &quot;AthenaGlueServiceRole-AthenaRole&quot;. This could also be created in the IAM console. Click &quot;Next&quot;.

![](RackMultipart20211103-4-zdfe80_html_8fc6ebf604a6b8bd.png)

The option for creating a schedule for this crawler is to define the frequency of the crawler usage. The different options from the dropdown menu would be – On demand, hourly, daily, choose days, weekly, monthly etc. We can use hourly, daily if we anticipate that the new data added in the folder could change the schema of the table. I chose &quot;Run on demand&quot; since I have chosen only one file in the bucket and not adding any new data in the bucket to be crawled for now. Click &quot;Next&quot;.

![](RackMultipart20211103-4-zdfe80_html_dd168d5de31220d9.png)

We need to choose a database where the table definition will be added. If we do not have any database to use, we can click &quot;Add database&quot;. This prompts us to give a name to the database. I named it as &quot;amazon\_review&quot;. Click &quot;create&quot;.

![](RackMultipart20211103-4-zdfe80_html_154f7078c7d39d5b.png)

![](RackMultipart20211103-4-zdfe80_html_b621e95262d85842.png)

If we want to add any prefix to the table, we can add it in the optional field &quot;Prefix added to the table&quot;. For example, as we have Review and Product data, we can use them as prefix. We can prefix the table by category as well, if we wish to upload both review and metadata/product data for more than one category. If we want to group compatible schema types into a single table then ticking the &quot;Create a single schema for each S3 path&quot; option in &quot;Grouping behavior for S3 data&quot; section is recommended for the large dataset when we expect the files can have the same data format. The configuration option helps us to deal with the frequency of the crawling. If we choose frequency as daily, hourly it is asking what we want to do in a frequent basis – update the table definition or add only the new columns or ignore the changes and do not update. Based on our use case we can select these options. I chose the default options. Click &quot;Next&quot;.

![](RackMultipart20211103-4-zdfe80_html_60b43df18a651f0c.png)

Review the options we have chosen. Click &quot;Finish&quot;.

![](RackMultipart20211103-4-zdfe80_html_3e6e90cc5a0e7aeb.png)

**Step 3:** Run the crawler and create the table &quot;mags\_sub&quot;.

Crawler is created. This can take a few minutes. Using the refresh icon, we can check the status. When it is &quot;Ready&quot;, it will give us a message as &quot;Crawler review\_crawler was created to run on demand&quot; at the top. We can click &quot;Run it now?&quot; otherwise we can select the crawler and &quot;Run crawler&quot;. This attempts to run the crawler.

![](RackMultipart20211103-4-zdfe80_html_d7581df091eaa5ad.png)

If we refresh, the status will turn &quot;Starting&quot; from &quot;Ready&quot;.

![](RackMultipart20211103-4-zdfe80_html_91d9a707014980f5.png)

When the cawler runs it will create logs that we can see under the &quot;Logs&quot; column. After waiting for a while if we refresh, we will see the crawler is ready and the number of tables created in the &quot;Table added&quot; column which is 1 for this particular column.

![](RackMultipart20211103-4-zdfe80_html_8ef52c521ce1a38d.png)

If we want to see the backend activity we can go to the AWS CloudWatch&quot; console. Click &quot;Log groups&quot; under &quot;Logs&quot; option. Click &quot;/aws-glue/crawlers&quot; group.

![](RackMultipart20211103-4-zdfe80_html_58de4514bbd39ff3.png)

Click &quot;review\_crawler&quot;.

![](RackMultipart20211103-4-zdfe80_html_c4a7ed0106f5d514.png)

If we expand the arrows, we can see that the crawler has &quot;created a table&quot; behind the scene.

![](RackMultipart20211103-4-zdfe80_html_4317adeb33532362.png)

If we click the &quot;Database&quot; page under &quot;Data catalog&quot;, we will see we have a database named &quot;amazon\_review&quot;.

![](RackMultipart20211103-4-zdfe80_html_cbb9452066bca17a.png)

If we click the &quot;Tables&quot; page under &quot;Data catalog&quot;, we will see we have a table named &quot;mag\_subs&quot;.

![](RackMultipart20211103-4-zdfe80_html_19884d86531b1a4d.png)

We can click the table name and view the properties which is in a JSON structure.

![](RackMultipart20211103-4-zdfe80_html_b1c79e65eac57491.png)

If we check the schema, we will see the data is not in the right format yet, hence not query able by Athena engine. Using this raw table will through us error if we try to query it now. We will normalize the JSON data by running Glue jobs by instating GlueContext and SparkContext object from awsglue and pyspark context libraries. Before that we would do some configuration across Glue and IAM.

![](RackMultipart20211103-4-zdfe80_html_899b51c5598cd8df.png)

**Step 4:** IAM Configuration.

Reference: https://docs.aws.amazon.com/glue/latest/dg/create-an-iam-role.html

Attaching a managed policy to IAM AWSGlueServiceRole-AthenaRole to access Amazon S3 resources.

![](RackMultipart20211103-4-zdfe80_html_59c74037d111917b.png)

Click the role. Navigate to &quot;Permissions&quot;, click &quot;Attach policies&quot;.

![](RackMultipart20211103-4-zdfe80_html_921171cc55b03515.png)

Search for keyword &quot;S3&quot;. Select &quot;AmazonS3FullAccess&quot; and click &quot;Attach policy&quot;.

![](RackMultipart20211103-4-zdfe80_html_eda1d84c4850d8c4.png)

We already have the AWSGlueServiceRole from the crawler creation.

![](RackMultipart20211103-4-zdfe80_html_2fa4403e8234cc55.png)

![](RackMultipart20211103-4-zdfe80_html_c65e4622c54803a.png)

**Step 5:** Set up a Dev endpoints &quot;asha\_json\_transform&quot;

AWS offers Dev endpoint where we can create code in IDE. This actually works with PyCharm professional or notebooks servers (Zeppelin or Sagemaker). Dev endpoints allows us to integrate our IDE or notebook directly into Glue. The endpoints are costly though. Make sure to delete the endpoint after the work is done.

![](RackMultipart20211103-4-zdfe80_html_7849a020db391e4a.png)

We want to give a name to the endpoint. I named it as &quot;asha\_json\_transform&quot;. I have used the same IAM role &quot;AWSGlueServiceRole-AthenaRole&quot; that has required permissions we need. Click &quot;Next&quot;.

![](RackMultipart20211103-4-zdfe80_html_a541609167f9ce11.png)

I have &quot;skipped the networking information&quot; as we are using S3. If we have used AWS RDS, we need to choose a connection with the particular database.

![](RackMultipart20211103-4-zdfe80_html_8e704e363cd408af.png)

I have included the commands to generate ssh key in &quot;aasha\_generate\_ssh public key.bash&quot; file in my git repo.

![](RackMultipart20211103-4-zdfe80_html_a009b89aaaf25cc2.png)

Copy/clip the key content from the id\_rsa.pub and paste it in the box. Click &quot;Next&quot;.

![](RackMultipart20211103-4-zdfe80_html_79fcb06f0f724178.png)

Review everything that we have just configured and click &quot;Finish&quot;.

![](RackMultipart20211103-4-zdfe80_html_8fe68488e39d4900.png)

Wait till the provision status turns &quot;Ready&quot;. This may take10-15 minutes. Using the refresh icon/navigating to the AWS CloudWatch we can observe the process behind the scene until the endpoint is ready.

![](RackMultipart20211103-4-zdfe80_html_c17c8064faf62f6d.png)

Step 6: Create a notebook using the endpoint

Once the endpoint is ready, click &quot;Notebooks&quot; from the &quot;ETL Section&quot;. Click &quot;Create notebook&quot;.

![](RackMultipart20211103-4-zdfe80_html_8c82bd19a2f0fa9e.png)

Give the notebook a name. I named it as &quot;aws-glue-asha-json-transform&quot;. Attach the endpoint created in the previous step. Update policy or create or use existing IAM role. Since I did not have any AWS Glue Service SageMaker Notebook Role, I have created one and called it &quot;AWSGlueServiceSageMakerNotebookRole-project-6190&quot;.

![](RackMultipart20211103-4-zdfe80_html_d3607f587fb9b5f9.png)

Keeping everything else as default, click &quot;Create notebook&quot;.

![](RackMultipart20211103-4-zdfe80_html_be3259ae46a997f6.png)

Wait until the status is &quot;Ready&quot;.

![](RackMultipart20211103-4-zdfe80_html_bebe1f09f1cd6b0.png)

Once ready. Click on the notebook. Click the &quot;Open&quot; tab. This will open a notebook environment.

![](RackMultipart20211103-4-zdfe80_html_c43312f9bee65cb.png)

**Step 7:** Use Pyspark Kernel in a new notebook. Click &quot;New&quot;. Select the Sparkmagic pyspark kernel.

![](RackMultipart20211103-4-zdfe80_html_5ea64e58740901e7.png)

**Step 8:** Write and execute the codes and save the flattened output JSON data in S3 bucket.

I have included the codes and markdowns in &quot;aws-glue-pyspark\_flatten\_json.ipynb&quot; which is available in github. I have used AWS Glue Relationalize Transform to handle the nested JSON.

Reference link: https://aws.amazon.com/blogs/big-data/simplify-querying-nested-json-with-the-aws-glue-relationalize-transform/

![](RackMultipart20211103-4-zdfe80_html_6fea4144c8d02e9d.png)

Objective 2. Perform one or more queries (or other actions!) over your data set _ **in the cloud** _.

**Step 9:** Configure Athena

Got to Amazon Athena console. Click &quot;Explore the query editor&quot;.

![](RackMultipart20211103-4-zdfe80_html_2b4a29a449988d9b.png)

We need to save the query result in an output location. I have created a folder in my s3 bucket (s3://afsana/athena-output//) and will be using it as the destination folder. Without the output folder querying will throw error.

![](RackMultipart20211103-4-zdfe80_html_e5da326b7b17b07b.png)

Go back to Athena. From the &quot;Query Editor&quot; page. click &quot;View Settings&quot;.

![](RackMultipart20211103-4-zdfe80_html_62b645a733767881.png)

Click &quot;Manage&quot;.

![](RackMultipart20211103-4-zdfe80_html_d93292c2e277cc35.png)

Click &quot;Browse S3&quot;.

![](RackMultipart20211103-4-zdfe80_html_3322269738daf708.png)

Click on the specific bucket that contains the output folder. In my case it is s3://afsana.

![](RackMultipart20211103-4-zdfe80_html_d89e8875cf2ab14e.png)

Select the target folder &quot;athena-output&quot;. Click &quot;Choose&quot;.

![](RackMultipart20211103-4-zdfe80_html_b081a4cbb722ed87.png)

Click &quot;Save&quot;.

![](RackMultipart20211103-4-zdfe80_html_743f03942f42750b.png)

Step 8: Create a Hive table by executing queries in AWS Athena

Go back to the &quot;Editor&quot;. Select &quot;AWSDataCatalog&quot; as Data Source. Use any database. I have used a new database called &quot;review&quot;. Using + icon open a Query tab. Run the Create Table statement shared in &quot;aws\_athena\_queries\_checkpoint1.sql&quot;. Once completed this will create the table mags\_sub, which we can expand using the (+) icon. We will now see the expected data format is there for each of the columns. We can also observe the Time in queue and Run time. The query is executed within seconds. This query saves the output is one of the columnar file formats Optimized Row Columnar (ORC) format which prevails an efficient way to store data in Hive and to improve query performance while dealing with big data.

![](RackMultipart20211103-4-zdfe80_html_9cd3e60c0e236b88.png)

Run the second query shared in &quot;aws\_athena\_queries\_checkpoint1.sql&quot;, which is a simple GROUP BY COUNT statement. The query has been executed in less than a second. The result output rows the number of reviews for each overall magazine subscriptions ratings. For example, total of 53790 records have overall 5.0 stars for magazine subscription category in Amazon.

![](RackMultipart20211103-4-zdfe80_html_2f132b4e3b0435b0.png)

