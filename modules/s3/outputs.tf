output "bucket_arn" {
  value = aws_s3_bucket.artifact_bucket.arn
}

output "bucket_name" {
  value = aws_s3_bucket.artifact_bucket.id
}