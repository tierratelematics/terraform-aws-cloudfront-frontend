variable "project" {
  description = "Name of project"
}

variable "environment" {
  description = "Name of environment (i.e. dev, test, prod)"
}

variable "region" {
  description = "Aws Region"
}

variable "route53_zone_id" {
  description = "Route 53 zone id"
}

variable "default_root_path" {
  description = "The default root path"
  default = ""
}

variable "viewer_protocol_policy" {
  description = "The protol policy"
  default = "redirect-to-https"
}

variable "viewer_certificate" {
  type = "map"
  description = "All certificate parameters"
  default = {
    cloudfront_default_certificate = true
  }
}

variable "alias_domain_suffix" {
  description = "Alias domain suffix"
}

variable "ssl_cert_id" {
  description = "The ssl cert id"
}

variable "list_public_register_alias_domain" {
  description = "Register.it alias domain"
  type = "list"
}

variable "brands" {
  description = "Frontend brand"
  type = "list"
}

variable "default_ttl" {
  description = "The default ttl"
  default = 3600
}

variable "max_ttl" {
  description = "The max ttl"
  default = 86400
}

variable "min_ttl" {
  description = "The min ttl"
  default = 0
}

variable "cache_compress" {
  description = "Compress resources"
  default = true
}
