resource "aws_s3_bucket_object" "layer_source" {
  bucket = var.bucket_name
  key    = var.object_key
  source = var.filename

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5(var.filename)
}
resource "aws_lambda_layer_version" "deps_layer" {
  layer_name   = var.name
  s3_bucket = aws_s3_bucket_object.layer_source.bucket
  s3_key = aws_s3_bucket_object.layer_source.key
  s3_object_version = aws_s3_bucket_object.layer_source.version_id

  compatible_runtimes = ["python3.9"]
}