resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  # using depends_on in root level. we don't need it here probably
  # depends_on = var.s3_bucket_acl_depends_on

  bucket = var.bucket_id
  acl    = var.s3_bucket_acl
}
