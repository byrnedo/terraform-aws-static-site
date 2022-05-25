module "aws-static-site" {
  source           = "./modules/s3_cloudfront_site"
  certificate_arn  = var.certificate_arn
  domain           = var.domain
  aliases          = var.aliases
  zone_id          = var.zone_id
  path_lambda_arns = var.lambda_arns
  single_page_app  = var.single_page_app
  enabled          = var.enabled
}


variable "certificate_arn" {
  description = "The ARN of the CloudFront certificate to use."
}
variable "domain" {
  description = "The main domain of the site"
}
variable "aliases" {
  type        = list(string)
  description = "Other domains of the site"
}

variable "zone_id" {
  description = "The AWS zone id to create the site in."
}

variable "lambda_arns" {
  description = "Map of path patterns to lambda ARNs"
  type        = map(string)
  default     = {}
}

variable "single_page_app" {
  description = "Set to true to serve all requests to index.html"
  default     = false
}

variable "enabled" {
  description = "Enable the cloudfront distribution"
  default     = true
}