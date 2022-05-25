
resource "aws_s3_bucket" "bucket" {
  bucket        = var.domain
  region        = var.region
  acl           = "public-read"
  force_destroy = "false"

  website {
    error_document = "error.html"
    index_document = "index.html"
  }
}

data "template_file" "bucket_policy_tmpl" {
  template = file("${path.module}/s3_public_policy.tpl")
  vars = {
    bucket = aws_s3_bucket.bucket.bucket
  }
}

resource "aws_s3_bucket_policy" "policy" {
  bucket = var.domain
  policy = data.template_file.bucket_policy_tmpl.rendered
}


module "cloudfront" {
  source = "../cloudfront_dist"
  comment = "For ${var.domain} app"
  website_endpoint = aws_s3_bucket.bucket.website_endpoint
  enabled          = var.enabled
  aliases          = concat([var.domain], var.aliases)
  certificate_arn  = var.certificate_arn
  single_page_app = var.single_page_app
  path_lambda_arns = var.path_lambda_arns
  lambda_arn = var.lambda_arn
  zone_id =  var.zone_id
}

resource aws_iam_user deploy_user {
  name = "deploy_${var.domain}"
}

data "template_file" "deploy_policy_tmpl" {
  template = file("${path.module}/deploy_policy.tpl")
  vars = {
    bucket = aws_s3_bucket.bucket.bucket
    distribution_arn = module.cloudfront.arn
  }
}

resource aws_iam_user_policy deploy_policy {
  policy = data.template_file.deploy_policy_tmpl.rendered
  user = aws_iam_user.deploy_user.name
}

resource aws_iam_access_key deploy_key {
  user = aws_iam_user.deploy_user.name
}

