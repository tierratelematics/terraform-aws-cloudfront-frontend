resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "Access identity for tierra-${var.project}-${var.region}-${var.environment}-cloudfront"
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::tierra-${var.project}-${var.region}-${var.environment}-cloudfront/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::tierra-${var.project}-${var.region}-${var.environment}-cloudfront"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }
}

resource "aws_s3_bucket" "bucket_app" {
  bucket = "tierra-${var.project}-${var.region}-${var.environment}-cloudfront"
  policy = "${data.aws_iam_policy_document.s3_policy.json}"

  tags {
    Name = "tierra-${var.project}-${var.region}-${var.environment}-cloudfront"
    Project = "${var.project}"
    Environment = "${var.environment}"
  }
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = "${aws_s3_bucket.bucket_app.bucket_domain_name}"
    origin_id = "${var.project}-${var.region}-${var.environment}-origin"
    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
    }
    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  enabled = true
  comment = "Cloud Front for ${var.project} (${var.environment})"

  aliases = ["${var.alias_domain}"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.project}-${var.region}-${var.environment}-origin"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "${var.viewer_protocol_policy}"
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400
  }

  default_root_object = "${var.default_root_path}index.html"
  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  "viewer_certificate" {
    iam_certificate_id = "${var.ssl_cert_id}"
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1"
  }

  custom_error_response = [
    {
      error_caching_min_ttl = "0",
      error_code = "400",
      response_code = "200",
      response_page_path = "/index.html"
    },
    {
      error_caching_min_ttl = "0",
      error_code = "404",
      response_code = "200",
      response_page_path = "/index.html"
    },
    {
      error_caching_min_ttl = "0",
      error_code = "403",
      response_code = "200",
      response_page_path = "/index.html"
    }]

  tags {
    Project = "${var.project}"
    Environment = "${var.environment}"
  }
}
