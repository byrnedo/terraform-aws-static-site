variable "website_endpoint" { 
    description = "The upstream website domain"
}
variable "zone_id" {}

variable "comment" { 
    description = "Text comment to help describe the distribution"
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
    description = "Arn of ssl certificate"
}

variable "aliases" {
    description =  "Domain names"
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

