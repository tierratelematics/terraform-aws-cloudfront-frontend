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
- `environment` - environment name (i.e. dev,test,prod)
- `region` - aws region
- `default_root_path` - project default root path (default "")
- `alias_domain` - Alias Domain Name
- `ssl_cert_id` - The ssl Certificate id

Usage
-----
```hcl
module "cloudfront-s3" {
  source = "github.com/tierratelematics/terraform-aws-cloudfront-frontend"
  project = "ninjagoat-frontend"
  environment = "dev"
  region = "eu-west-1"
  alias_domain = "prettygoat-fe.tierratelematic.com"
  ssl_cert_id = "idSSLCert"
}
```

Outputs
=======
- `bucket_name` - aws bucket name
- `cloudfront_url` - aws cloudfront url
- `policy_arn` - aws policy arn
- `cloufront_hosted_zone_id` - aws cloufroont hosted zone id

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