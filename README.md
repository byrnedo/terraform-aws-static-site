# Terraform AWS Static Site Module

![aws](aws.png)

An opinionated module to easily create an S3 hosted static site, served via Cloudfront with TLS and optionally attach lambdas to certain paths.

```terraform
module "site" {
  source  = "byrnedo/static-site/aws"
  version = "0.1.3"
  domain = "www.foo.com"
  aliases = [ "foo.com"]
  zone_id = "some-zone-id-you-have"
  certificate_arn = "some-certificate-arn-you-have"
}
```

Strong Opinions:

- You want TLS (https)
- The created bucket name is the domain name.
- You want an IAM user with permissions to deploy to the bucket and invalidate the cache.
- You don't have any georestrictions.
- With `vars.single_page_app` set to true, you want all requests served from index.html. When false, will serve `404.html` for any file not found in the bucket.

