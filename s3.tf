resource "aws_kms_key" "tf-bucket-key" {
  description = "Key used to encrypt bucket objects"
}

resource "aws_kms_alias" "key-alias" {
  name = "alias/tf-bucket-key-${random_integer.suffix.id}"
  target_key_id = aws_kms_key.tf-bucket-key.key_id
}

resource "aws_s3_bucket" "state-store" {
  bucket = "ce-session-tfstate-bucket-${random_integer.suffix.id}"
  force_destroy = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.state-store.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.tf-bucket-key.arn
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_acl" "state-store-acl" {
  bucket = aws_s3_bucket.state-store.id
  acl = "private"
}

resource "aws_s3_bucket_versioning" "state-store-version" {
  bucket = aws_s3_bucket.state-store.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "state-store-access" {
  bucket = aws_s3_bucket.state-store.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform-state" {
  name = "terraform-state-${random_integer.suffix.id}"
  read_capacity = 20
  write_capacity = 20
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "random_integer" "suffix" {
  min = 1
  max = 100000
}


