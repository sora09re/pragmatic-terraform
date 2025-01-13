# プライベートバケット
resource "aws_s3_bucket" "private" {
  bucket = "s-aoki-private-pragmatic-terraform"
}

resource "aws_s3_bucket_versioning" "private" {
  bucket = aws_s3_bucket.private.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "private" {
  bucket = aws_s3_bucket.private.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "private" {
  bucket                  = aws_s3_bucket.private.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# パプリックバケット
resource "aws_s3_bucket" "public" {
  bucket = "s-aoki-public-pragmatic-terraform"
}

resource "aws_s3_bucket_public_access_block" "public" {
  bucket                  = aws_s3_bucket.public.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

data "aws_iam_policy_document" "public" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.public.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "public" {
  bucket = aws_s3_bucket.public.id
  policy = data.aws_iam_policy_document.public.json

  # デフォルトではパブリックアクセスブロックが有効化されているので、先に無効化
  depends_on = [aws_s3_bucket_public_access_block.public]
}

resource "aws_s3_bucket_cors_configuration" "public" {
  bucket = aws_s3_bucket.public.id

  cors_rule {
    allowed_origins = ["https://example.com"]
    allowed_methods = ["GET"]
    allowed_headers = ["*"]
    max_age_seconds = 3000
  }
}
