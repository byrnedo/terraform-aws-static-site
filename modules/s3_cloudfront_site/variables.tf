variable domain {
  description = "The domain for the app"
}

variable aliases {
  description = "Other domains"
  type = list(string)
  default = []
}

variable "enabled" {
  default = false
}

variable "single_page_app" {
  description = "Whether or not this is a single page app and needs 404s redirected to index"
  default = false
}

variable "lambda_arn" {
  description = "Arn of lambda to run upon viewer-request"
  default = ""
}

variable "path_lambda_arns" {
  description = "map of path_patterns to lambda_arn"
  type = map(string)
  default = {}
}
variable "certificate_arn" {
  type = string
}
variable "zone_id" {}

variable "region" {
  type = string
}
