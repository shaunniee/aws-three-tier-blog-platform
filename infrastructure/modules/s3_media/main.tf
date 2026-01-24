resource "aws_vpc_endpoint" "s3_endpoint" {
    vpc_id            = var.vpc_id
    service_name      = "com.amazonaws.eu-west-1.s3"
    vpc_endpoint_type = "Gateway"
    
    route_table_ids = [var.app_rt_id]
    
    tags = merge(
        var.tags,
        {
        Name = "${var.name_prefix}-s3-endpoint"
        }
    )
  
}




resource "aws_s3_bucket" "s3_media" {
    bucket = "${var.name_prefix}-media-bucket"
    tags = merge(
        var.tags,
        {
            Name = "${var.name_prefix}-media-bucket"
        }
    )
}


resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
    bucket = aws_s3_bucket.s3_media.id

    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
  
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.s3_media.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "s3_media_bucket_policy" {
    bucket = aws_s3_bucket.s3_media.id

   policy = jsonencode({
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = ["s3:GetObject","s3:PutObject"]
        Resource = "${aws_s3_bucket.s3_media.arn}/*"
        Condition = {
          StringEquals = {
            "aws:sourceVpce" = aws_vpc_endpoint.s3_endpoint.id
          }
        }
      }
    ]
  })
}
