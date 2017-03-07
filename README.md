# cloudfront-ninjagoat
This is a terraform module useful to create a static site on Cloudfront with data on S3

### Requirements
* Terraform v0.8.5 or higher

### Example of usage
```terraform
module "cloudfront-s3" {
    source = "modules/cloudfront-website"
    project = "preattygoat"
    environment = "dev"
    region = "eu-west-1"
    default_root_object = "index.html"
    default_root_path = ""
}

output "bucket_name" {
    value = "${module.cloudfront-s3.bucket_name}"
}

output "cloudfront_url" {
    value = "${module.cloudfront-s3.cloudfront_url}"
}

output "policy_arn" {
    value = "${module.cloudfront-s3.policy_arn}"
}
```