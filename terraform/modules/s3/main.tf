data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "backup" {
  bucket = "${var.project}-${var.env}-backup-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name = "${var.project}-${var.env}-backup"
  }
}

resource "aws_s3_bucket_public_access_block" "backup" {
  bucket = aws_s3_bucket.backup.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "backup" {
  bucket = aws_s3_bucket.backup.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "backup" {
  bucket = aws_s3_bucket.backup.id

  rule {
    id     = "delete-old-backups"
    status = "Enabled"

    filter {}

    expiration {
      days = 30
    }
  }
}
