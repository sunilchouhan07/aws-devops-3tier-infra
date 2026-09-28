resource "aws_iam_role" "ec2_role" {
  name = "${var.project}-${var.env}-ec2-role"

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


resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}


resource "aws_iam_role_policy" "secret_manager_policy" {
  name = "${var.project}-${var.env}-secret-manager-pilicy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = {
      Effect = "Allow"
      Action = [
        "secretsmanager:GetSecretValue"
      ]
      Resource = var.db_secret_arn
    }
  })
}


resource "aws_iam_role_policy" "s3_artifact_policy" {
  name = "${var.project}-${var.env}-s3-artifact-policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject"
        ]

        Resource = "${var.artifact_bucket_arn}/*"

      }
    ]
  })
}

resource "aws_iam_role_policy" "ssm_parameter_policy" {
  name = "${var.project}-${var.env}-ssm-parameter-policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "ssm:GetParameter"
        ]

        Resource = [
          var.db_parameter_host,
          var.db_parameter_port,
          var.db_parameter_secret_arn,
          var.current_version,
          var.cloudwatch_agent_parameter_arn
        ]
      }
    ]
  })
}

