# Terraform AWS Static Site Module

An opinionated module to easily create an S3 hosted static site, served via Cloudfront with TLS and optionally attach lambdas to certain paths.

Strong Opinions:

- The created bucket name is the domain name.
- You want an IAM user with permissions to deploy to the bucket and invalidate the cache.
- You don't have any georestrictions.
- With `vars.single_page_app` set to true, you want all requests served from index.html. When false, will serve `404.html` for any file not found in the bucket.

