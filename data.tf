data "archive_file" "zip" {
  type        = "zip"
  source_file = "welcome.py"
  output_path = "welcome.zip"
}
data "aws_iam_policy_document" "policy" {
  statement {
    sid    = ""
    effect = "Allow"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}