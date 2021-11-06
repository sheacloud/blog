resource "aws_s3_bucket" "primary" {
    bucket = "${var.bucket_name}-${local.environment}-${data.aws_region.primary.name}"
    acl    = "private"

    tags = {
        Name        = "My bucket"
    }

    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm     = "AES256"
            }
        }
    }
}

resource "aws_s3_bucket_policy" "primary_cloudfront" {
    bucket = aws_s3_bucket.primary.id

    policy = <<EOF
{
    "Version": "2008-10-17",
    "Id": "PolicyForCloudFrontPrivateContent",
    "Statement": [
        {
            "Sid": "CloudFront",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${aws_cloudfront_origin_access_identity.content.iam_arn}"
            },
            "Action": "s3:GetObject",
            "Resource": "${aws_s3_bucket.primary.arn}/*"
        }
    ]
}
EOF
}




resource "aws_s3_bucket" "secondary" {
    provider = aws.secondary
    bucket = "${var.bucket_name}-${local.environment}-${data.aws_region.secondary.name}"
    acl    = "private"

    tags = {
        Name        = "My bucket"
    }

    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm     = "AES256"
            }
        }
    }
}

resource "aws_s3_bucket_policy" "secondary_cloudfront" {
    provider = aws.secondary
    bucket = aws_s3_bucket.secondary.id

    policy = <<EOF
{
    "Version": "2008-10-17",
    "Id": "PolicyForCloudFrontPrivateContent",
    "Statement": [
        {
            "Sid": "CloudFront",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${aws_cloudfront_origin_access_identity.content.iam_arn}"
            },
            "Action": "s3:GetObject",
            "Resource": "${aws_s3_bucket.secondary.arn}/*"
        }
    ]
}
EOF
}