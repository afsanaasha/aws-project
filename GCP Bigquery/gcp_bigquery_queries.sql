CREATE EXTERNAL TABLE mag_subs_review (
	overall bigint
    vote int,
	verified bit,
	image struct
	reviewTime string
	reviewerID string
	asin string
    style array
        structFormat string,
             Size string,
             Color string,
	reviewerName string
	reviewText string
	summary string
	unixReviewTime bigint
)

)