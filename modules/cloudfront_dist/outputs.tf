output "arn" {
    value = aws_cloudfront_distribution.dist.arn
}
output "domain" {
    value = aws_cloudfront_distribution.dist.domain_name
}