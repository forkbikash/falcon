resource "aws_s3_bucket_ownership_controls" "s3_bucket_ownership_controls" {
  bucket = var.bucket_id
  rule {
    object_ownership = var.s3_bucket_ownership_controls_rule_object_ownership
  }
}
