output "instance_role_arn" {
  description = "ARN of the IAM role for LogRhythm instances"
  value       = aws_iam_role.logrhythm_instance_role.arn
}

output "instance_role_name" {
  description = "Name of the IAM role for LogRhythm instances"
  value       = aws_iam_role.logrhythm_instance_role.name
}

output "instance_profile_arn" {
  description = "ARN of the IAM instance profile"
  value       = aws_iam_instance_profile.logrhythm_profile.arn
}

output "instance_profile_name" {
  description = "Name of the IAM instance profile"
  value       = aws_iam_instance_profile.logrhythm_profile.name
}
