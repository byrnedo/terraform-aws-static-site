output cloudfront_distribution {
  value = module.cloudfront.distribution
}

output deploy_user {
  value = aws_iam_user.deploy_user
}

output deploy_key {
  value = aws_iam_access_key.deploy_key
}



