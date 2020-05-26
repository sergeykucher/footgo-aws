
resource "aws_iam_role" "ec2_s3_read_only_role" {
  name               = "ec2_s3_read_only_role"
  assume_role_policy = var.assume_role_policy
}

resource "aws_iam_policy" "s3_read_only_policy" {
  name        = "s3_read_only_policy"
  description = "S3 bucket read-only policy"
  policy      = var.policy
}

resource "aws_iam_policy_attachment" "ec2_s3_read_only_attachment" {
  name       = "ec2_s3_read_only_attachment"
  roles      = [aws_iam_role.ec2_s3_read_only_role.name]
  policy_arn = aws_iam_policy.s3_read_only_policy.arn
}

resource "aws_iam_instance_profile" "es2_s3_read_only_profile" {
  name = "es2_s3_read_only_profile"
  role = aws_iam_role.ec2_s3_read_only_role.name
}
