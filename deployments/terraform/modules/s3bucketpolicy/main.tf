resource "aws_s3_bucket_policy" "example" {
  bucket = var.bucket_id

  policy = var.bucket_policy
}
