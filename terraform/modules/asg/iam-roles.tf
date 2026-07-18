resource "aws_iam_role" "ec2_deployment_role" {
  name = "${var.env}-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}




resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2_deployment_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}



resource "aws_iam_policy" "deployment_bucket_read" {
  name = "${var.env}-deployment-bucket-read"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]

        Resource = [
          var.artifact_bucket_arn,
          "${var.artifact_bucket_arn}/*"
        ]
      }
    ]
  })
}



resource "aws_iam_role_policy_attachment" "deployment_bucket_read" {
  role       = aws_iam_role.ec2_deployment_role.name
  policy_arn = aws_iam_policy.deployment_bucket_read.arn
}



resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.env}-instance-profile"
  role = aws_iam_role.ec2_deployment_role.name
}