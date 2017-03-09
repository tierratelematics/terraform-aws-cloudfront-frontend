# cloudfront-ninjagoat
This is a terraform module useful to create a static site on Cloudfront with data on S3

### Requirements
* Terraform v0.8.5 or higher

### Variables
```
variable "project" {
   description = "Name of project"
 }
 
 variable "environment" {
   description = "Name of environment (i.e. dev, test, prod)"
 }
 
 variable "region" {
   description = "Aws Region"
 }
 
 variable "bucketName" {
   description = "the bucketName"
   default = ""
 }
 
 variable "default_root_object" {
   description = "The default root object"
   default = "index.html"
 }
 
 variable "default_root_path" {
   description = "The default root path"
   default = ""
 }
 ```

### Outputs
```
output "bucket_name" {
    value = "${aws_s3_bucket.bucket_app.id}"
}

output "cloudfront_url" {
    value = "${aws_cloudfront_distribution.s3_distribution.domain_name}"
}

output "policy_arn" {
    value = "${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"
}
```

## Example of usage
```terraform
module "cloudfront-s3" {
    source = "../../modules/cloudfront-s3"
    project = "project"
    environment = "env"
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

