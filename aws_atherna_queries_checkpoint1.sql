CREATE EXTERNAL TABLE IF NOT EXISTS review.mags_sub (
  `overall` double,
  `vote` string,
  `verified` boolean,
  `reviewTime` string,
  `reviewerID` string,
  `asin` string,
  `reviewerName` string,
  `reviewText` string,
  `summary` string,
  `unixReviewTime` int,
  `style.Format:` string,
  `image` string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.orc.OrcSerde'
WITH SERDEPROPERTIES (
  'serialization.format' = '1'
) LOCATION 's3://afsana/json_flat/'
TBLPROPERTIES ('has_encrypted_data'='false');



SELECT * FROM review.mags_sub LIMIT 5;