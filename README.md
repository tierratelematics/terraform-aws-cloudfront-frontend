AWS Cloudfront Frontend Terraform module
===========
A terraform module to deploy a Frontend Project on cloudfront (Amazon CDN)

Requirements
===========
* Terraform v0.8.5 or higher
* AWS Certificate Arn

Module Input Variables
----------------------
- `project` - project name
- `brands` - list of brand
- `environment` - environment name (i.e. dev,test,prod)
- `region` - aws region
- `default_root_path` - project default root path (default "")
- `alias_domain_suffix` - Alias Suffix Domain Name
- `ssl_cert_id` - The ssl Certificate id (if you want to use the certificate's arn, you do not have to set this variable)
- `ssl_cert_arn` - The ssl Certificate arn (if you want to use the certificate's id, you do not have to set this variable)
- `list_public_register_alias_domain` - List of Register.it alias domain
- `default_ttl` - default ttl (default "3600")
- `max_ttl` - max ttl (default "86400")
- `min_ttl` - min ttl (default "0")
- `cache_compress` - Compress resources (default true)

Usage
-----
```hcl
module "cloudfront-s3" {
  source = "github.com/tierratelematics/terraform-aws-cloudfront-frontend"
  project = "ninjagoat-frontend"
  environment = "dev"
  region = "eu-west-1"
  alias_domain_suffix = "tierra.io"
  ssl_cert_id = "idSSLCert"
  list_public_register_alias_domain = ["prettygoat-fe.tierratelematics.com"]
  brands = ["main"]
}
```

Outputs
=======
- `list_bucket_name` - aws bucket names
- `list_cloudfront_url` - aws cloudfront urls
- `cloufront_hosted_zone_id` - aws cloudfront hosted zone id
- `list_dns_internal_domain` - DNS internal domains
- `list_dns_public_domain` - DNS public domains

License
=======
Copyright 2017 Tierra SpA

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.