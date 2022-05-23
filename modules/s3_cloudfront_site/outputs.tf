output distribution_arn {
  value = module.cloudfront.arn
}

output iam_user {
  value = aws_iam_user.deploy_user.name
}

output aws_access_key_id {
  value = aws_iam_access_key.deploy_key.id
}

output aws_secret_access_key {
  sensitive = true
  value = aws_iam_access_key.deploy_key.secret
}

output domain {
  value = module.cloudfront.domain
}

