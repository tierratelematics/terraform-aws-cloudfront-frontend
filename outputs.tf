output "bucket_name" {
    value = "${aws_s3_bucket.bucket_app.id}"
}

output "cloudfront_url" {
    value = "${aws_cloudfront_distribution.s3_distribution.domain_name}"
}

output "policy_arn" {
    value = "${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"
}
