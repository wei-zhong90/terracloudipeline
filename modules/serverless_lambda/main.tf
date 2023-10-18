resource "random_id" "id" {
  keepers = {
    # Generate a new id each time we switch to a new request id
    req_id = var.req_id
  }

  byte_length = 8
}


resource "aws_iam_role" "iam_for_lambda" {
  name               = random_id.id.hex
  assume_role_policy = data.aws_iam_policy_document.policy.json
  tags = merge(
    var.additional_tags,
    {
      req = random_id.id.keepers.req_id
    },
  )

  lifecycle {
    # The function tags must contain "env=test".
    postcondition {
      condition     = self.tags["env"] == "test"
      error_message = "tags[\"env\"] must be \"test\"."
    }
  }
}
resource "aws_lambda_function" "lambda" {
  function_name = random_id.id.hex
  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256
  role    = aws_iam_role.iam_for_lambda.arn
  handler = "welcome.lambda_handler"
  runtime = "python3.8"

  tags = merge(
    var.additional_tags,
    {
      req = random_id.id.keepers.req_id
    },
  )

  lifecycle {
    # The function tags must contain "env=test".
    postcondition {
      condition     = self.tags["env"] == "test"
      error_message = "tags[\"env\"] must be \"test\"."
    }
  }
}