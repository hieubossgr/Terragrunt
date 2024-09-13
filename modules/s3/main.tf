resource "aws_s3_bucket" "artifact_bucket" {
  bucket = "${var.bucket_name}"

  tags = {
    Name = var.bucket_name
  }
}

resource "aws_vpc_endpoint" "s3_gateway" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.ap-southeast-1.s3"
  route_table_ids = var.route_table_ids

  tags = {
    Name = "S3 Gateway Endpoint"
  }
}