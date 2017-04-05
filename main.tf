data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::tierra-${var.project}-${var.brand}-${var.region}-${var.environment}-cloudfront/*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket" "bucket_app" {
  bucket = "tierra-${var.project}-${var.brand}-${var.region}-${var.environment}-cloudfront"
  policy = "${data.aws_iam_policy_document.s3_policy.json}"

  website {
    index_document = "index.html"
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }

  tags {
    Name = "tierra-${var.project}-${var.brand}-${var.region}-${var.environment}-cloudfront"
    Project = "${var.project}"
    Environment = "${var.environment}"
    Brand = "${var.brand}"
  }
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = "tierra-${var.project}-${var.brand}-${var.region}-${var.environment}-cloudfront.s3-website-eu-west-1.amazonaws.com"
    origin_id = "${var.project}-${var.brand}-${var.region}-${var.environment}-origin"
    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  enabled = true
  comment = "Cloud Front for ${var.project} [Brand: ${var.brand}] (${var.environment})"

  aliases = ["${var.alias_domain}","${var.public_register_alias_domain}"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.project}-${var.brand}-${var.region}-${var.environment}-origin"
    compress = "${var.cache_compress}"

    forwarded_values {
      query_string = false
      headers = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "${var.viewer_protocol_policy}"
    min_ttl = "${var.min_ttl}"
    default_ttl = "${var.default_ttl}"
    max_ttl = "${var.max_ttl}"
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
    Brand = "${var.brand}"
  }
}
