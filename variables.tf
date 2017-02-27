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