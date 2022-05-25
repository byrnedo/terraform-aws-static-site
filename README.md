# Terraform AWS Static Site Module

![aws](aws.png)

An opinionated module to easily create an S3 hosted static site, served via Cloudfront with TLS and optionally attach lambdas to certain paths.

```terraform
module "site" {
  source  = "byrnedo/static-site/aws"
  version = "0.1.3"
  domain = "www.foo.com"
  aliases = [ "foo.com"]
  region = "eu-west-1"
  zone_id = "some-zone-id-you-have"
  certificate_arn = "some-certificate-arn-you-have"
}
```

## Resources created:

- S3 bucket
- Cloudfront distribution
- IAM user
- Route53 records for domain and aliases

## Strong Opinions:

- You want TLS (https with auto redirect from http)
- The created bucket name is the domain name.
- You want an IAM user with permissions to deploy to the bucket and invalidate the cache.
- You don't have any georestrictions.
- With `vars.single_page_app` set to true, you want all requests served from index.html. When false, will serve `404.html` for any file not found in the bucket.

