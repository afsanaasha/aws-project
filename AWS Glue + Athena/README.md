# cloud-project

Checkpoint#1
DSBA 6190 Checkpoint #1 Student Name: Afsana Akther Asha

Data Source: http://deepyeti.ucsd.edu/jianmo/amazon/

Category choosen: Magagize Subscription

**Objective 1. Load into the Cloud either product JSON (called &quot;metadata&quot; on the source github) or review JSON from at least one category of Amazon data.**

**Step 1: Upload the amazon JSON data in S3 bucket.**

I chose review data for &quot;Magazine\_Subscriptions.json&quot; and my bucket path is s3://afsana where I loaded the json data

(![image](https://user-images.githubusercontent.com/73313035/140012138-3acce59c-8031-493a-a19e-4c5c4e0b70c5.png)


**Step 2: Create a crawler in AWS Glue.**

Go to AWS Glue console. Glue is an ETL service where we will use crawler to create table. From the Data Catalog section click on &quot;Crawlers&quot;. This will take into a page that says &quot;you do not have any crawlers yet&quot;. Click on &quot;Add a crawler&quot;.

![image](https://user-images.githubusercontent.com/73313035/140012216-018c104b-8177-45c2-aaab-2cf4d5ccee8c.png) ![image](https://user-images.githubusercontent.com/73313035/140013335-3d9cc683-11e1-4203-8164-e350c560b350.png)


Give it a name in the Crawler name field. I named it as &quot;review\_crawler&quot;. Extending the arrow, we can also provide tag, description and security configuration. Tags will help us to categorized resources. Since they are optional, I kept this section empty.

![image](https://user-images.githubusercontent.com/73313035/140012274-2361d7e1-d013-45a0-b8e1-8819e8722d17.png)


Click Next. We need to specify the crawler source type. I used the default source type which is &quot;Data stores&quot;. But we can use existing catalog tables as well.

![image](https://user-images.githubusercontent.com/73313035/140012306-a8709579-bd56-4b1a-8859-95c05f1456de.png)


We can add the datastore from S3, DynaboDB or JDBC connection type. I chose &quot;S3&quot; as my datastore since my data is in S3.

![image](https://user-images.githubusercontent.com/73313035/140012321-35fe96d1-0254-4d12-9a34-fba9c1a55097.png)


After that need to include the S3 path. Click on the file icon beside &quot;Include path&quot; field. I need to crawl &quot;s3://afsana/Magagize\_Subscriptions.json&quot; only, therefore I only selected that. If we need to crawl all data in a particular folder, we can choose that folder in the bucket as well. Click &quot;Select&quot;. Then we can use the optional &quot;Exclude path&quot; option to exclude any subfolder (for instance, in this case athena-output) in the s3://afsana that we do not want to scan and crawl to create table name and definitions. If mentioned log/\*\* it will skip all the subfolders inside the logs if we have any. I kept it empty as I only chose a particular data file. Click &quot;Next&quot;.

![image](https://user-images.githubusercontent.com/73313035/140012338-f6647192-4e27-46d4-9693-443a1794ea75.png)


It will ask if we want to add another datastore. I selected &quot;No&quot;. Click &quot;Next&quot;.

![image](https://user-images.githubusercontent.com/73313035/140012347-2c88e324-02e8-473a-a512-095540e1bc86.png)


This will bring us to an important step asking us to choose an IAM role. We need to have S3 read permission to read the data. We can provide Athena GetObject action to S3 and Glue. For Glue this is necessary because the crawler need to scan and fetch the meta data information after reading the file. For Athena it is also required to access the folder for which we will be running queries. If we have already created IAM role it will let us choose from the existing IAM roles. As I do not have any, I created an IAM role as &quot;AthenaGlueServiceRole-AthenaRole&quot;. This could also be created in the IAM console. Click &quot;Next&quot;.

![image](https://user-images.githubusercontent.com/73313035/140012360-ba1c3111-dda8-4259-8c8a-70378993ba03.png)


The option for creating a schedule for this crawler is to define the frequency of the crawler usage. The different options from the dropdown menu would be – On demand, hourly, daily, choose days, weekly, monthly etc. We can use hourly, daily if we anticipate that the new data added in the folder could change the schema of the table. I chose &quot;Run on demand&quot; since I have chosen only one file in the bucket and not adding any new data in the bucket to be crawled for now. Click &quot;Next&quot;.

![image](https://user-images.githubusercontent.com/73313035/140012385-274fc187-6d31-4201-8f43-1ddfe141fab7.png)


We need to choose a database where the table definition will be added. If we do not have any database to use, we can click &quot;Add database&quot;. 

![image](https://user-images.githubusercontent.com/73313035/140012405-c59144c6-9ac6-4aad-a9cb-f242141cff1d.png)


This prompts us to give a name to the database. I named it as &quot;amazon\_review&quot;. Click &quot;create&quot;.

![image](https://user-images.githubusercontent.com/73313035/140012461-8224be84-f82a-4b54-9389-c124be0bdb0f.png)


If we want to add any prefix to the table, we can add it in the optional field &quot;Prefix added to the table&quot;. For example, as we have Review and Product data, we can use them as prefix. We can prefix the table by category as well, if we wish to upload both review and metadata/product data for more than one category. If we want to group compatible schema types into a single table then ticking the &quot;Create a single schema for each S3 path&quot; option in &quot;Grouping behavior for S3 data&quot; section is recommended for the large dataset when we expect the files can have the same data format. The configuration option helps us to deal with the frequency of the crawling. If we choose frequency as daily, hourly it is asking what we want to do in a frequent basis – update the table definition or add only the new columns or ignore the changes and do not update. Based on our use case we can select these options. I chose the default options. Click &quot;Next&quot;.

![image](https://user-images.githubusercontent.com/73313035/140012466-ddbe3267-4661-48aa-939c-16f307a33070.png)


Review the options we have chosen. Click &quot;Finish&quot;.

![image](https://user-images.githubusercontent.com/73313035/140012480-a9bab68c-339e-4b2a-9cf6-e19a7084c4a2.png)


**Step 3: Run the crawler and create the table &quot;mags\_sub&quot;.**

Crawler is created. This can take a few minutes. Using the refresh icon, we can check the status. When it is &quot;Ready&quot;, it will give us a message as &quot;Crawler review\_crawler was created to run on demand&quot; at the top. We can click &quot;Run it now?&quot; otherwise we can select the crawler and &quot;Run crawler&quot;. This attempts to run the crawler.

![image](https://user-images.githubusercontent.com/73313035/140012526-22d10936-f5dd-4049-a1bc-358a61bcb3ef.png)


If we refresh, the status will turn &quot;Starting&quot; from &quot;Ready&quot;.

![image](https://user-images.githubusercontent.com/73313035/140012537-b0a1716a-d0e3-4ef1-a71a-4bedee9f55c1.png)


When the cawler runs it will create logs that we can see under the &quot;Logs&quot; column. After waiting for a while if we refresh, we will see the crawler is ready and the number of tables created in the &quot;Table added&quot; column which is 1 for this particular column.

![image](https://user-images.githubusercontent.com/73313035/140012550-9f589d77-3ae2-42ec-be06-dfbe5b1bdd32.png)


If we want to see the backend activity we can go to the AWS CloudWatch&quot; console. Click &quot;Log groups&quot; under &quot;Logs&quot; option. Click &quot;/aws-glue/crawlers&quot; group.

![image](https://user-images.githubusercontent.com/73313035/140012561-d785c68b-3440-465c-a016-0b16a4371782.png)


Click &quot;review\_crawler&quot;.

![image](https://user-images.githubusercontent.com/73313035/140012573-54a0b4ca-de01-4ab9-bfce-fcb175dd3cb2.png)


If we expand the arrows, we can see that the crawler has &quot;created a table&quot; behind the scene.
![image](https://user-images.githubusercontent.com/73313035/140012591-d08586ff-eec0-4e1e-ada1-64c0074405c1.png)


If we click the &quot;Database&quot; page under &quot;Data catalog&quot;, we will see we have a database named &quot;amazon\_review&quot;.

![image](https://user-images.githubusercontent.com/73313035/140012609-27c2bc3d-18d7-4f4b-9f26-c5bc1df7219b.png)


If we click the &quot;Tables&quot; page under &quot;Data catalog&quot;, we will see we have a table named &quot;mag\_subs&quot;.

![image](https://user-images.githubusercontent.com/73313035/140012616-5126e4af-c53e-41b4-be8f-85263c23480f.png)


We can click the table name and view the properties which is in a JSON structure.

![image](https://user-images.githubusercontent.com/73313035/140012630-8bb494f7-9f4f-4e5e-a989-80ee7dee2ec3.png)


If we check the schema, we will see the data is not in the right format yet, hence not query able by Athena engine. Using this raw table will through us error if we try to query it now. We will normalize the JSON data by running Glue jobs by instating GlueContext and SparkContext object from awsglue and pyspark context libraries. Before that we would do some configuration across Glue and IAM.

![image](https://user-images.githubusercontent.com/73313035/140012662-f52fa912-aa46-4a78-9f60-ba30f9f2562f.png)


**Step 4: IAM Configuration.**

Reference: https://docs.aws.amazon.com/glue/latest/dg/create-an-iam-role.html

Attaching a managed policy to IAM AWSGlueServiceRole-AthenaRole to access Amazon S3 resources.

![image](https://user-images.githubusercontent.com/73313035/140012678-c6062950-c156-4105-b156-a59e2646a0ba.png)


Click the role. Navigate to &quot;Permissions&quot;, click &quot;Attach policies&quot;.

![image](https://user-images.githubusercontent.com/73313035/140012688-20fe9f8b-9f48-4a0a-b3c4-69e6e2325a3c.png)


Search for keyword &quot;S3&quot;. Select &quot;AmazonS3FullAccess&quot; and click &quot;Attach policy&quot;.

![image](https://user-images.githubusercontent.com/73313035/140012697-cf154b89-7719-4a2e-a59a-1d27017e08e3.png)


We already have the AWSGlueServiceRole from the crawler creation.

![image](https://user-images.githubusercontent.com/73313035/140012706-0352093a-7438-41a3-b948-e2dcb6748f55.png)

![image](https://user-images.githubusercontent.com/73313035/140012709-7f34ca5f-42a7-4bc7-9156-3fb8dfbdcf77.png)


**Step 5: Set up a Dev endpoints &quot;asha\_json\_transform&quot;**

AWS offers Dev endpoint where we can create code in IDE. This actually works with PyCharm professional or notebooks servers (Zeppelin or Sagemaker). Dev endpoints allows us to integrate our IDE or notebook directly into Glue. The endpoints are costly though. Make sure to delete the endpoint after the work is done.

![image](https://user-images.githubusercontent.com/73313035/140012730-d84ce835-ae26-4825-a934-efb079dee2ff.png)


We want to give a name to the endpoint. I named it as &quot;asha\_json\_transform&quot;. I have used the same IAM role &quot;AWSGlueServiceRole-AthenaRole&quot; that has required permissions we need. Click &quot;Next&quot;.

![image](https://user-images.githubusercontent.com/73313035/140012742-327fd464-4b7a-43d5-93ad-bdad53cc803f.png)


I have &quot;skipped the networking information&quot; as we are using S3. If we have used AWS RDS, we need to choose a connection with the particular database.

![image](https://user-images.githubusercontent.com/73313035/140012759-9f1d5a93-bc06-4db7-b779-323fce8e279d.png)


I have included the commands to generate ssh key in &quot;aasha\_generate\_ssh public key.bash&quot; file in my git repo.

![image](https://user-images.githubusercontent.com/73313035/140012769-847005d3-1f46-4576-adce-94405de20919.png)


Copy/clip the key content from the id\_rsa.pub and paste it in the box. Click &quot;Next&quot;.

![image](https://user-images.githubusercontent.com/73313035/140012779-42111226-20de-40f0-8617-e344793411ff.png)


Review everything that we have just configured and click &quot;Finish&quot;.

![image](https://user-images.githubusercontent.com/73313035/140012786-59c2f3b1-770c-4703-9189-eb087d325671.png)


Wait till the provision status turns &quot;Ready&quot;. This may take10-15 minutes. Using the refresh icon/navigating to the AWS CloudWatch we can observe the process behind the scene until the endpoint is ready.

![image](https://user-images.githubusercontent.com/73313035/140012794-43f1616e-5fba-4fa1-b463-1d7115e859e9.png)


**Step 6: Create a notebook using the endpoint.**

Once the endpoint is ready, click &quot;Notebooks&quot; from the &quot;ETL Section&quot;. Click &quot;Create notebook&quot;.

![image](https://user-images.githubusercontent.com/73313035/140012822-c68b1fe0-aed1-430a-b21a-717c4c3c3e1d.png)


Give the notebook a name. I named it as &quot;aws-glue-asha-json-transform&quot;. Attach the endpoint created in the previous step. Update policy or create or use existing IAM role. Since I did not have any AWS Glue Service SageMaker Notebook Role, I have created one and called it &quot;AWSGlueServiceSageMakerNotebookRole-project-6190&quot;.

![image](https://user-images.githubusercontent.com/73313035/140012836-7b45c022-9c25-4ddf-b335-85448bcd8f7c.png)


Keeping everything else as default, click &quot;Create notebook&quot;.

![image](https://user-images.githubusercontent.com/73313035/140012841-5c189212-0902-49d8-bddf-952ddae2beb3.png)


Wait until the status is &quot;Ready&quot;.

![image](https://user-images.githubusercontent.com/73313035/140012856-de13d8e3-1c35-4f22-a837-e663e85a0ee9.png)


Once ready. Click on the notebook. Click the &quot;Open&quot; tab. This will open a notebook environment.

![image](https://user-images.githubusercontent.com/73313035/140012880-543699c8-7155-42b8-b75e-d7955334d9b5.png)


**Step 7: Use Pyspark Kernel in a new notebook. Click &quot;New&quot;. Select the Sparkmagic pyspark kernel.**

![image](https://user-images.githubusercontent.com/73313035/140012895-a60e1256-b763-47bf-9d88-1839f5089658.png)


**Step 8: Write and execute the codes and save the flattened output JSON data in S3 bucket.**

I have included the codes and markdowns in &quot;aws-glue-pyspark\_flatten\_json.ipynb&quot; which is available in github. I have used AWS Glue Relationalize Transform to handle the nested JSON.

Reference link: https://aws.amazon.com/blogs/big-data/simplify-querying-nested-json-with-the-aws-glue-relationalize-transform/

![image](https://user-images.githubusercontent.com/73313035/140012909-931214cb-0de1-4064-8b57-df6be3c47919.png)


**Objective 2. Perform one or more queries (or other actions!) over your data set _ *in the cloud* _.**

**Step 9: Configure Athena**

Got to Amazon Athena console. Click &quot;Explore the query editor&quot;.

![image](https://user-images.githubusercontent.com/73313035/140012960-d1f7edd0-b0dd-44ad-a1e3-74b889ac7e48.png)


We need to save the query result in an output location. I have created a folder in my s3 bucket (s3://afsana/athena-output//) and will be using it as the destination folder. Without the output folder querying will throw error.

![image](https://user-images.githubusercontent.com/73313035/140012968-a09fea5a-9305-44ed-b3f6-5b08dc990e1f.png)


Go back to Athena. From the &quot;Query Editor&quot; page. click &quot;View Settings&quot;.

![image](https://user-images.githubusercontent.com/73313035/140012972-aacaab7e-35aa-4bb0-afc5-6c072f7e31e9.png)


Click &quot;Manage&quot;.

![image](https://user-images.githubusercontent.com/73313035/140012987-4decc0d5-1431-4b61-b5c0-fa17256f6eba.png)


Click &quot;Browse S3&quot;.

![image](https://user-images.githubusercontent.com/73313035/140013000-547bf599-342b-4beb-8476-bf6314b5199c.png)


Click on the specific bucket that contains the output folder. In my case it is s3://afsana.

![image](https://user-images.githubusercontent.com/73313035/140013021-b167c52a-fb9d-4760-909e-6cd69dbdf015.png)


Select the target folder &quot;athena-output&quot;. Click &quot;Choose&quot;.

![image](https://user-images.githubusercontent.com/73313035/140013029-95d1b349-7806-4099-a409-bb4eaf83b6e9.png)


Click &quot;Save&quot;.

![image](https://user-images.githubusercontent.com/73313035/140013043-672a46d3-e39e-4fd5-9844-80a5c01fd00a.png)


**Step 10: Create a Hive table by executing queries in AWS Athena.**

Go back to the &quot;Editor&quot;. Select &quot;AWSDataCatalog&quot; as Data Source. Use any database. I have used a new database called &quot;review&quot;. Using + icon open a Query tab. Run the Create Table statement shared in &quot;aws\_athena\_queries\_checkpoint1.sql&quot;. Once completed this will create the table mags\_sub, which we can expand using the (+) icon. We will now see the expected data format is there for each of the columns. We can also observe the Time in queue and Run time. The query is executed within seconds. This query saves the output is one of the columnar file formats Optimized Row Columnar (ORC) format which prevails an efficient way to store data in Hive and to improve query performance while dealing with big data.

![image](https://user-images.githubusercontent.com/73313035/140013071-95df8d79-a286-4b3c-b83b-cefafb23b212.png)


**Step 11: Perform queries using the table created**
Run the second query shared in &quot;aws\_athena\_queries\_checkpoint1.sql&quot;, which is a simple GROUP BY COUNT statement. The query has been executed in less than a second. The result output rows the number of reviews for each overall magazine subscriptions ratings. For example, total of 53790 records have overall 5.0 stars for magazine subscription category in Amazon.

![image](https://user-images.githubusercontent.com/73313035/140013085-d7a2c09f-be49-4654-9882-46c615ab503f.png)

