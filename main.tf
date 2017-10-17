provider "template" {
  version = "~> 1.0"
}

data "template_file" "bucket_name" {
  count    = "${length(var.brands)}"
  template = "$${name}"

  vars {
    name = "${substr(format("%s-%s-%s-%s", var.project, var.brands[count.index], var.region, var.environment), 0, ((length(format("%s-%s-%s-%s", var.project, var.brands[count.index], var.region, var.environment)) > 45) ? 45 : -1))}"
  }
}

data "aws_iam_policy_document" "s3_policy" {
  count = "${length(var.brands)}"

  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::tierra-${element(data.template_file.bucket_name.*.rendered,count.index)}-cloudfront/*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket" "bucket_app" {
  count  = "${length(var.brands)}"
  bucket = "tierra-${element(data.template_file.bucket_name.*.rendered,count.index)}-cloudfront"
  policy = "${element(data.aws_iam_policy_document.s3_policy.*.json,count.index)}"

  website {
    index_document = "index.html"
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["http://*", "https://*"]
  }

  force_destroy = true

  tags {
    Name        = "tierra-${var.project}-${element(var.brands,count.index)}-${var.region}-${var.environment}-cloudfront"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    Brand       = "${element(var.brands,count.index)}"
  }
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  count = "${length(var.brands)}"

  origin {
    domain_name = "tierra-${element(data.template_file.bucket_name.*.rendered,count.index)}-cloudfront.s3-website-eu-west-1.amazonaws.com"
    origin_id   = "${element(data.template_file.bucket_name.*.rendered,count.index)}-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled = true
  comment = "Cloud Front for ${var.project} [Brand: ${element(var.brands,count.index)}] (${var.environment})"

  aliases = ["${var.project}-${var.environment}-${element(var.brands,count.index)}.${var.alias_domain_suffix}", "${element(var.list_public_register_alias_domain, count.index)}"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.project}-${element(var.brands,count.index)}-${var.region}-${var.environment}-origin"
    compress         = "${var.cache_compress}"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "${var.viewer_protocol_policy}"
    min_ttl                = "${var.min_ttl}"
    default_ttl            = "${var.default_ttl}"
    max_ttl                = "${var.max_ttl}"
  }

  default_root_object = "${var.default_root_path}index.html"
  price_class         = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  "viewer_certificate" {
    iam_certificate_id       = "${var.ssl_cert_id}"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
  }

  custom_error_response = [
    {
      error_caching_min_ttl = "0"
      error_code            = "400"
      response_code         = "200"
      response_page_path    = "/index.html"
    },
    {
      error_caching_min_ttl = "0"
      error_code            = "404"
      response_code         = "200"
      response_page_path    = "/index.html"
    },
    {
      error_caching_min_ttl = "0"
      error_code            = "403"
      response_code         = "200"
      response_page_path    = "/index.html"
    },
  ]

  tags {
    Project     = "${var.project}"
    Environment = "${var.environment}"
    Brand       = "${element(var.brands,count.index)}"
  }
}

resource "aws_route53_record" "cdn-cname" {
  count = "${length(var.brands)}"

  zone_id = "${var.route53_zone_id}"
  name    = "${var.project}-${var.environment}-${element(var.brands,count.index)}.${var.alias_domain_suffix}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${element(aws_cloudfront_distribution.s3_distribution.*.domain_name, count.index)}"]
}
