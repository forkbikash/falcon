resource "aws_s3_bucket" "s3_bucket" {
  # Enable versioning for the bucket
  # versioning {
  #   enabled = true
  # }

  bucket = var.bucket
}
