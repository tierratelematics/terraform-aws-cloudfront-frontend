output "bucket_name" {
    value = "${aws_s3_bucket.bucket_app.id}"
}

output "cloudfront_url" {
    value = "${aws_cloudfront_distribution.s3_distribution.domain_name}"
}

output "policy_arn" {
//    value = "${aws_iam_policy.aws_iam_policy_document.}"
        value = ""
}
