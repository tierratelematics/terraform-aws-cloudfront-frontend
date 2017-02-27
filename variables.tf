variable "project" {
  description = "Name of project"
}

variable "environment" {
  description = "Name of environment (i.e. dev, test, prod)"
}

variable "region" {
  description = "Aws Region"
}

variable "custom_errores" {
  type = "list"
  description = "List of custom errores"
  default = []
}