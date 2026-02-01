resource "aws_cloudfront_origin_access_identity" "frontend_oai" {
  comment = "OAI for Blog Frontend"
}

resource "aws_cloudfront_distribution" "frontend_cdn" {
  enabled             = true
  default_root_object = "index.html"

  origin {
    domain_name = var.bucket_regional_domain_name
    origin_id   = "s3-frontend"
    
  
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.frontend_oai.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-frontend"

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "Blog Frontend CDN"
  }
}

resource "aws_s3_bucket_policy" "frontend_bucket_policy" {
  bucket = var.frontend_bucket

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.frontend_oai.iam_arn
        },
        Action = "s3:GetObject",
        Resource = "arn:aws:s3:::${var.frontend_bucket}/*"
      }
    ]
  })
}