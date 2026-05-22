resource "aws_iam_role" "backup" {
  name = "${var.project}-${var.env}-backup-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "backup_s3" {
  name = "${var.project}-${var.env}-backup-s3"
  role = aws_iam_role.backup.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:PutObject",
        "s3:GetObject",
        "s3:ListBucket"
      ]
      Resource = [
        var.backup_bucket_arn,
        "${var.backup_bucket_arn}/*"
      ]
    }]
  })
}

resource "aws_iam_instance_profile" "backup" {
  name = "${var.project}-${var.env}-backup-profile"
  role = aws_iam_role.backup.name
}
