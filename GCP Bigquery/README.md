# cloud-project

DSBA 6190 Checkpoint #1 Student Name: Afsana Akther Asha

Data Source: http://deepyeti.ucsd.edu/jianmo/amazon/

Category choosen: Magagize Subscription Review data

**Objective 1. Load into the Cloud either product JSON (called &quot;metadata&quot; on the source github) or review JSON from at least one category of Amazon data.**

**Step 1: Creating a dataset in BigQuery Console.**

From your project Dashboard, open the BigQuery page in the cloud console or directly navigate to BigQuery \&gt; SQL workspace.

![image](https://user-images.githubusercontent.com/73313035/140254329-29f104a3-79dd-4c67-a681-d06c03d86a13.png)


In the Explorer panel, select the project where you want to create the dataset. Expand the vertical ellipsis &quot;Actions&quot; option and click &quot;Create dataset **&quot;**.

![image](https://user-images.githubusercontent.com/73313035/140254370-ec48d57d-d3f3-4665-ba98-5411e6260838.png)


On the &quot;Create dataset&quot; page: For &quot;Dataset ID&quot;, enter a unique dataset name. I named it as &quot;amazon\_review&quot;. For &quot;Data location&quot;, choose the geographic location &quot;US (multiple regions in United States)&quot; for the dataset. After a dataset is created, the location can&#39;t be changed. For &quot;Default table expiration&quot;, I selected the default option which is &quot;Never&quot; **.** With this option tables we will be creating created in the dataset are never automatically deleted. We need to delete them manually. Click &quot;Create dataset&quot;.

![image](https://user-images.githubusercontent.com/73313035/140254412-80d6390b-4fc3-426c-8f4c-bc383f6a028d.png)


**Step 2:**  **Creating a table by manually writing JSON schema.**

In the Explorer panel, expand the project and select the dataset we just created in the previous step. Expand the vertical ellipsisActions option and click &quot;Open&quot;. In the details panel, click &quot;Create table&quot;.

![image](https://user-images.githubusercontent.com/73313035/140254531-acb9a42e-a8f2-4396-9d63-338dce75f714.png)


On the &quot;Create table **&quot;**  page, in the &quot;Source&quot; section, select  **&quot;** Upload **&quot;.**

![image](https://user-images.githubusercontent.com/73313035/140254612-de4e3c90-d81e-4d79-b116-6ae1d436bd22.png)


In the Select file field, browse to or enter the full path to the JSON file location. For &quot;File format&quot; **,** select &quot;JSON (Newline delimited)&quot; if not automatically detected.

![image](https://user-images.githubusercontent.com/73313035/140254677-372eceed-ddf6-481b-995b-9e90e5a2d2c6.png)


On the &quot;Create table&quot; page, in the &quot;Destination&quot; section: Choose the appropriate &quot;Project&quot; destination. In my case this is &quot;project-aasha&quot;. For &quot;Dataset ID&quot;, give the name for &quot;amazon\_review&quot; dataset. In the &quot;Table name&quot; field, enter the name of the table you&#39;re creating in BigQuery. I named the table as &quot;mag\_subs&quot;. Verify that &quot;Table type&quot; is set to Native table. In the Schema section, instead of enabling &quot;Auto detect&quot;, I manually entered the schema definition by enabling Edit as text and entering the table schema as a JSON array.

![image](https://user-images.githubusercontent.com/73313035/140254744-ad3f01d6-37d4-4200-831b-e03e42814ba1.png)


Using the understanding on the data type properties that BigQuery supports such as integers, as well as more complex types such as ARRAY and STRUCT), I coded the JSON schema, which can be found in the Git repo named as &quot;gcp\_bigquery\_json\_schema.json&quot;. To create the &quot;style&quot; column for Magazine\_Subscriptions nested data, set the data type of the column to RECORD in the schema. A RECORD can be accessed as a [STRUCT](https://cloud.google.com/bigquery/docs/reference/standard-sql/data-types#struct_type) type in standard SQL. A STRUCT is a container of ordered fields. The &quot;image&quot; column has repeated data, hence we can set the mode of this column to REPEATED in the schema. A repeated field can be accessed as an [ARRAY](https://cloud.google.com/bigquery/docs/reference/standard-sql/data-types#array_type) type in standard SQL. A RECORD column can have REPEATED mode, which is represented as an array of STRUCT types. Also, a field within a record can be repeated, which is represented as a STRUCT that contains an ARRAY. An array cannot contain another array directly.

Reference: https://cloud.google.com/bigquery/docs/reference/standard-sql/data-types#declaring\_an\_array\_type

![image](https://user-images.githubusercontent.com/73313035/140254814-10f770c3-7bdc-4a1e-ae04-8b65a3d5fc54.png)


In the &quot;Advanced options **&quot;**  choose the write disposition &quot;Write if empty&quot; from default setting Append to table, this allows write the data only if the table is empty. Check &quot;Unknown values&quot;. Click &quot; **C** reate Table&quot;. Look for error messages while creating the table and troubleshoot along the way:

[https://www.oreilly.com/library/view/google-bigquery-the/9781492044451/ch04.html](https://www.oreilly.com/library/view/google-bigquery-the/9781492044451/ch04.html)

[https://cloud.google.com/bigquery/docs/error-messages](https://cloud.google.com/bigquery/docs/error-messages).
![image](https://user-images.githubusercontent.com/73313035/140254883-8fec8939-fd9d-4243-8f85-188a4d209a9f.png)


It will notify us if the job got sucessful. We can click on the &quot;Job history&quot; for more details.

![image](https://user-images.githubusercontent.com/73313035/140254911-52125247-5089-4ba0-ac9c-425882d6f176.png)


Expand the vertical ellipsis &quot;Actions&quot; option and click the table &quot;mag\_subs&quot;.

![image](https://user-images.githubusercontent.com/73313035/140254962-d0374d00-ec21-4c83-9ae5-0521b3b0f7c5.png)


We can now see the correct table schema loaded from the JSON file.

![image](https://user-images.githubusercontent.com/73313035/140255013-56cfc8ff-a6de-4792-b5c5-2603d2d85088.png)

![image](https://user-images.githubusercontent.com/73313035/140255048-5fd637b2-c0fa-4ba2-9be8-e58f187ea831.png)


**Objective 2. Perform one or more queries (or other actions!) over your data set _ *in the cloud* _.**

**Step 3: Executing queries.**

After we load our data into BigQuery, can query the data in our tables. By default, BigQuery runs &quot;interactive&quot; queries, which means that the query is executed as soon as possible. Using the console again, Expand the project node. Click &quot;Query&quot; from the vertical more options from the table.

![image](https://user-images.githubusercontent.com/73313035/140255100-e5ee6952-2064-4ee4-996d-b47bf62f5aea.png)


Write and execute the simple query below by hitting the &quot;Run&quot; button:

SELECT count(\*), overall FROM `project-aasha.amazon_review.mag_subs` group by overall;

![image](https://user-images.githubusercontent.com/73313035/140255190-dd6468a6-ff1a-41c1-b665-641c67dd4627.png)


The output result is as below. BigQuery lets us save queries and share queries with others.When we save a query, it can be private (visible only to me), shared at the project level (visible to specific principals), or public (anyone can view it).

![image](https://user-images.githubusercontent.com/73313035/140255227-11ad1b33-412f-4e5b-8395-1901e7abad2a.png)
