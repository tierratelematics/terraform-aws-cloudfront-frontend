output "bucket_name" {
    value = "${aws_s3_bucket.bucket_app.id}"
}

output "cloudfront_url" {
    value = "${aws_cloudfront_distribution.s3_distribution.domain_name}"
}

output "cloufront_hosted_zone_id" {
    value = "${aws_cloudfront_distribution.s3_distribution.hosted_zone_id}"
}

output "cloudfront_distribution_id" {
    value = "${aws_cloudfront_distribution.s3_distribution.id}"
}