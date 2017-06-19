output "list_bucket_name" {
  value = "${aws_s3_bucket.bucket_app.*.id}"
}

output "list_cloudfront_url" {
  value = "${aws_cloudfront_distribution.s3_distribution.*.domain_name}"
}

output "cloufront_hosted_zone_id" {
  value = "${aws_cloudfront_distribution.s3_distribution.0.hosted_zone_id}"
}

output "list_cloudfront_distribution_id" {
  value = "${aws_cloudfront_distribution.s3_distribution.*.id}"
}

output "list_dns_internal_domain" {
  value = "${aws_route53_record.cdn-cname.*.name}"
}

output "list_dns_public_domain" {
  value = "${var.list_public_register_alias_domain}"
}
