resource "aws_cloudfront_origin_access_identity" "content" {}

data "aws_cloudfront_cache_policy" "caching" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
    origin_group {
        origin_id = "groupS3"

        failover_criteria {
            status_codes = [403, 404, 500, 502, 503, 504]
        }

        member {
            origin_id = "primary"
        }

        member {
            origin_id = "secondary"
        }
    }

    origin {
        domain_name = aws_s3_bucket.primary.bucket_regional_domain_name
        origin_id   = "primary"

        s3_origin_config {
            origin_access_identity = "origin-access-identity/cloudfront/${aws_cloudfront_origin_access_identity.content.id}"
        }
    }

    origin {
        domain_name = aws_s3_bucket.secondary.bucket_regional_domain_name
        origin_id   = "secondary"

        s3_origin_config {
            origin_access_identity = "origin-access-identity/cloudfront/${aws_cloudfront_origin_access_identity.content.id}"
        }
    }

    enabled             = true
    is_ipv6_enabled     = true
    default_root_object = "index.html"

    aliases = [local.domain_name]

    default_cache_behavior {
        allowed_methods  = ["GET", "HEAD", "OPTIONS"]
        cached_methods   = ["GET", "HEAD"]
        target_origin_id = "groupS3"

        cache_policy_id = data.aws_cloudfront_cache_policy.caching.id

        viewer_protocol_policy = "redirect-to-https"
        compress = true

        function_association {
          event_type = "viewer-request"
          function_arn = aws_cloudfront_function.index_rewritter.arn
        }
    }

    price_class = "PriceClass_All"

    tags = {
        Environment = "production"
    }

    viewer_certificate {
        acm_certificate_arn = aws_acm_certificate.website.arn
        minimum_protocol_version = "TLSv1.2_2021"
        ssl_support_method = "sni-only"
    }

    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }
}

resource "aws_cloudfront_monitoring_subscription" "s3_distribution" {
  count = terraform.workspace == "default" ? 1 : 0
  distribution_id = aws_cloudfront_distribution.s3_distribution.id

  monitoring_subscription {
    realtime_metrics_subscription_config {
      realtime_metrics_subscription_status = "Enabled"
    }
  }
}


resource "aws_cloudfront_function" "index_rewritter" {
  name    = "website-index-rewritter"
  runtime = "cloudfront-js-1.0"
  publish = true
  code    = <<EOF
function handler(event) {
    var request = event.request;
    // Extract the URI from the request
    var olduri = request.uri;

    // Match any '/' that occurs at the end of a URI. Replace it with a default index
    var newuri = olduri.replace(/\/$/, '\/index.html');

    // Replace the received URI with the URI that includes the index page
    request.uri = newuri;

    return request;
}
EOF
}