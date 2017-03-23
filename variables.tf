variable "project" {
  description = "Name of project"
}

variable "environment" {
  description = "Name of environment (i.e. dev, test, prod)"
}

variable "region" {
  description = "Aws Region"
}

variable "default_root_path" {
  description = "The default root path"
  default = ""
}

variable "viewer_protocol_policy" {
  description = "The protol policy"
  default = "https-only"
}

variable "viewer_certificate" {
  type = "map"
  description = "All certificate parameters"
  default = {
    cloudfront_default_certificate = true
  }
}

variable "alias_domain" {
  description = "Alias Domain Name"
}

variable "ssl_cert_id" {
  description = "The ssl cert id"
}

variable "public_register_alias_domain" {
  description = "Register.it alias domain"
}

variable "brand" {
  description = "Frontend brand"
}
