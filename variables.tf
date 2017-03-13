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
  default = "allow-all"
}

variable "viewer_certificate" {
  type = "map"
  description = "All certificate parameters"
  default = {
    cloudfront_default_certificate = true
  }
}

variable "aliases" {
  type = "list"
  description = "All cloudfront aliases"
  default = []
}
