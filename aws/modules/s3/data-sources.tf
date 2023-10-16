#Data sources
data "aws_s3_bucket" "s3_data" {
  bucket = aws_s3_bucket.s3.id
}