resource "aws_s3_bucket" "bucket_app" {
    bucket = "tierra-${var.project}-${var.region}-${var.environment}-cloudfront"
    acl = "private"
    region = "${var.region}"
    policy = <<EOF
{
	"Statement": [
		{
			"Sid": "AddPerm",
			"Effect": "Allow",
			"Principal": "*",
			"Action": "s3:GetObject",
			"Resource": "arn:aws:s3:::tierra-${var.project}-${var.region}-${var.environment}-cloudfront/*"
		}
	]
}
EOF
    tags {
        Name = "tierra-${var.project}-${var.region}-${var.environment}-cloudfront"
        Project = "${var.project}"
        Environment = "${var.environment}"
    }
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name =  "${aws_s3_bucket.bucket_app.bucket_domain_name}"
    origin_id   = "${var.project}-${var.region}-${var.environment}-origin"
  }

  enabled             = true
  comment             = "Cloud Front for ${var.project} (${var.environment})"

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

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags {
    Project = "${var.project}"
    Environment = "${var.environment}"
 }
}

resource "aws_iam_policy" "policy" {
    name = "${var.project}-${var.region}-${var.environment}-cloudfront-bucket-policy"
    description = "Policy for access to tierra-${var.project}-${var.region}-${var.environment}-cloudfront bucket"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::tierra-${var.project}-${var.region}-${var.environment}*/*",
                "arn:aws:s3:::tierra-${var.project}-${var.region}-${var.environment}*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "s3:ListAllMyBuckets",
            "Resource": "*"
        }
    ]
}
EOF
}
