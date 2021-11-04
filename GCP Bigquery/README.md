# cloud-project

Checkpoint#1
DSBA 6190 Checkpoint #1 Student Name: Afsana Akther Asha

Data Source: http://deepyeti.ucsd.edu/jianmo/amazon/

Category choosen: Magagize Subscription

Objective 1. Load into the Cloud either product JSON (called &quot;metadata&quot; on the source github) or review JSON from at least one category of Amazon data.


DSBA 6190 Checkpoint #1 Extra Credit Option Student Name: Afsana Akther Asha

**Step 1: Creating a dataset in BigQuery Console.**

From your project Dashboard, open the BigQuery page in the cloud console or directly navigate to BigQuery \&gt; SQL workspace.

![](RackMultipart20211104-4-kzfpdh_html_fde708998843b41d.png)

In the Explorer panel, select the project where you want to create the dataset. Expand the vertical ellipsis &quot;Actions&quot; option and click &quot;Create dataset **&quot;**.

![](RackMultipart20211104-4-kzfpdh_html_1f337e31472d2780.png)

On the &quot;Create dataset&quot; page: For &quot;Dataset ID&quot;, enter a unique dataset name. I named it as &quot;amazon\_review&quot;. For &quot;Data location&quot;, choose the geographic location &quot;US (multiple regions in United States)&quot; for the dataset. After a dataset is created, the location can&#39;t be changed. For &quot;Default table expiration&quot;, I selected the default option which is &quot;Never&quot; **.** With this option tables we will be creating created in the dataset are never automatically deleted. We need to delete them manually. Click &quot;Create dataset&quot;.

![](RackMultipart20211104-4-kzfpdh_html_7208793df2eb5b64.png)

**Step 2:**  **Creating a table by manually writing JSON schema.**

In the Explorer panel, expand the project and select the dataset we just created in the previous step.

Expand the vertical ellipsisActions option and click &quot;Open&quot;. In the details panel, click &quot;Create table&quot;.

![](RackMultipart20211104-4-kzfpdh_html_f542ecd0f520657c.png)

On the &quot;Create table **&quot;**  page, in the &quot;Source&quot; section, select  **&quot;** Upload **&quot;.**

![](RackMultipart20211104-4-kzfpdh_html_bd7a78252b132c57.png)

In the Select file field, browse to or enter the full path to the JSON file location. For &quot;File format&quot; **,** select &quot;JSON (Newline delimited)&quot; if not automatically detected.

![](RackMultipart20211104-4-kzfpdh_html_c598776fd26515ef.png)

On the &quot;Create table&quot; page, in the &quot;Destination&quot; section: Choose the appropriate &quot;Project&quot; destination. In my case this is &quot;project-aasha&quot;. For &quot;Dataset ID&quot;, give the name for &quot;amazon\_review&quot; dataset. In the &quot;Table name&quot; field, enter the name of the table you&#39;re creating in BigQuery. I named the table as &quot;mag\_subs&quot;. Verify that &quot;Table type&quot; is set to Native table.

In the Schema section, instead of enabling &quot;Auto detect&quot;, I manually entered the schema definition by enabling Edit as text and entering the table schema as a JSON array.

![](RackMultipart20211104-4-kzfpdh_html_f769ce58830b310a.png)

Using the understanding on the data type properties that BigQuery supports such as integers, as well as more complex types such as ARRAY and STRUCT), I coded the JSON schema, which can be found in the Git repo named as &quot;gcp\_bigquery\_json\_schema.json&quot;. To create the &quot;style&quot; column for Magazine\_Subscriptions nested data, set the data type of the column to RECORD in the schema. A RECORD can be accessed as a [STRUCT](https://cloud.google.com/bigquery/docs/reference/standard-sql/data-types#struct_type) type in standard SQL. A STRUCT is a container of ordered fields. The &quot;image&quot; column has repeated data, hence we can set the mode of this column to REPEATED in the schema. A repeated field can be accessed as an [ARRAY](https://cloud.google.com/bigquery/docs/reference/standard-sql/data-types#array_type) type in standard SQL. A RECORD column can have REPEATED mode, which is represented as an array of STRUCT types. Also, a field within a record can be repeated, which is represented as a STRUCT that contains an ARRAY. An array cannot contain another array directly.

Reference: https://cloud.google.com/bigquery/docs/reference/standard-sql/data-types#declaring\_an\_array\_type

![](RackMultipart20211104-4-kzfpdh_html_fee68cde736131ae.png)

In the &quot;Advanced options **&quot;**  choose the write disposition &quot;Write if empty&quot; from default setting Append to table, this allows write the data only if the table is empty. Check &quot;Unknown values&quot;. Click &quot; **C** reate Table&quot;. Look for error messages while creating the table and troubleshoot along the way:

[https://www.oreilly.com/library/view/google-bigquery-the/9781492044451/ch04.html](https://www.oreilly.com/library/view/google-bigquery-the/9781492044451/ch04.html)

[https://cloud.google.com/bigquery/docs/error-messages](https://cloud.google.com/bigquery/docs/error-messages).

![](RackMultipart20211104-4-kzfpdh_html_a45befc08ec2eb2d.png)

It will notify us if the job got sucessful. We can click on the &quot;Job history&quot; for more details.

![](RackMultipart20211104-4-kzfpdh_html_5e968ff9d19e8eba.png)

Expand the vertical ellipsis &quot;Actions&quot; option and click the table &quot;mag\_subs&quot;.

![](RackMultipart20211104-4-kzfpdh_html_c37641459f69142a.png)

We can now see the correct table schema loaded from the JSON file.

![](RackMultipart20211104-4-kzfpdh_html_9758ada47fbdd0f7.png)

![](RackMultipart20211104-4-kzfpdh_html_14de2814202745e4.png)

**Step 3: Executing queries.**

After we load our data into BigQuery, can query the data in our tables. By default, BigQuery runs &quot;interactive&quot; queries, which means that the query is executed as soon as possible. Using the console again, Expand the project node. Click &quot;Query&quot; from the vertical more options from the table.

![](RackMultipart20211104-4-kzfpdh_html_d1d05da11ab074c0.png)

Write and execute the simple query below by hitting the &quot;Run&quot; button:

SELECT count(\*), overall FROM `project-aasha.amazon_review.mag_subs` group by overall;

![](RackMultipart20211104-4-kzfpdh_html_2be1a8938a1901f7.png)

The output result is as below. BigQuery lets us save queries and share queries with others.When we save a query, it can be private (visible only to me), shared at the project level (visible to specific principals), or public (anyone can view it).

![](RackMultipart20211104-4-kzfpdh_html_2b5a0b5f374de62c.png)