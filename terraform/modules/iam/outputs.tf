output "ec2_role_name" {
  description = "EC2 IAM role name"
  value       = aws_iam_role.ec2_role.name
}

output "ec2_role_arn" {
  description = "EC2 IAM role ARN"
  value       = aws_iam_role.ec2_role.arn
}