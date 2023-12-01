resource "aws_cloudfront_distribution" "dist" {

  origin {
    domain_name = var.website_endpoint
    origin_id   = "S3-${var.website_endpoint}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = [
        "TLSv1",
        "TLSv1.1",
        "TLSv1.2"
      ]
    }
  }


  comment             = var.comment
  enabled             = var.enabled
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases             = var.aliases
  price_class         = "PriceClass_100"


  dynamic custom_error_response {
    for_each = var.single_page_app ? [1] : []
    content {
      error_code         = 404
      response_code      = 200
      response_page_path = "/index.html"
    }
  }
  dynamic custom_error_response {
    for_each = var.single_page_app ? [] : [1]
    content {
      error_caching_min_ttl = 300
      error_code            = 404
      response_code         = 404
      response_page_path    = "/404.html"
    }
  }

  default_cache_behavior {
    allowed_methods = [
      "HEAD",
      "GET"
    ]
    cached_methods = [
      "HEAD",
      "GET"
    ]
    target_origin_id = "S3-${var.website_endpoint}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    dynamic lambda_function_association {
      for_each = var.lambda_arn == "" ? [] : [1]
      content {
        lambda_arn   = var.lambda_arn
        event_type   = "viewer-request"
        include_body = false
      }
    }

    viewer_protocol_policy     = "redirect-to-https"
    min_ttl                    = 0
    default_ttl                = 86400
    max_ttl                    = 31536000
    response_headers_policy_id = aws_cloudfront_response_headers_policy.cors_policy.id
  }

  dynamic ordered_cache_behavior {
    for_each = var.path_lambda_arns

    content {
      allowed_methods = [
        "HEAD",
        "GET"
      ]
      cached_methods = [
        "HEAD",
        "GET"
      ]
      target_origin_id = "S3-${var.website_endpoint}"

      forwarded_values {
        query_string = false

        cookies {
          forward = "none"
        }
      }

      lambda_function_association {
        lambda_arn   = ordered_cache_behavior.value
        event_type   = "viewer-request"
        include_body = false
      }

      path_pattern           = ordered_cache_behavior.key
      viewer_protocol_policy = "redirect-to-https"
      min_ttl                = 0
      default_ttl            = 86400
      max_ttl                = 31536000
    }
  }


  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn      = var.certificate_arn
    minimum_protocol_version = "TLSv1.1_2016"
    ssl_support_method       = "sni-only"
  }
}

locals {
  all_domains = var.aliases
}
resource aws_route53_record domain {
  count = length(local.all_domains)
  name  = local.all_domains[count.index]
  type  = "A"
  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.dist.domain_name
    zone_id                = aws_cloudfront_distribution.dist.hosted_zone_id
  }
  zone_id = var.zone_id
}

resource "aws_cloudfront_response_headers_policy" "cors_policy" {
  name    = "${replace(var.aliases[0], ".", "-")}-cors-headers-policy"
  comment = "Allow CORS among aliases and main domain"

  cors_config {
    access_control_allow_methods {
      items = [
        "HEAD",
        "GET"
      ]
    }

    access_control_allow_headers {
      items = ["*"]
    }

    access_control_allow_origins {
      items = local.all_domains
    }

    origin_override                  = true
    access_control_allow_credentials = false
  }
}