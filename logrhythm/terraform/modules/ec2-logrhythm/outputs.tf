output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.logrhythm_component.id
}

output "private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.logrhythm_component.private_ip
}

output "availability_zone" {
  description = "Availability zone of the EC2 instance"
  value       = aws_instance.logrhythm_component.availability_zone
}

output "arn" {
  description = "ARN of the EC2 instance"
  value       = aws_instance.logrhythm_component.arn
}
