output "platform_manager_instance_id" {
  description = "Instance ID of the Platform Manager EC2 instance"
  value       = module.ec2_platform_manager.instance_id
}

output "platform_manager_private_ip" {
  description = "Private IP address of the Platform Manager EC2 instance"
  value       = module.ec2_platform_manager.private_ip
}

output "data_processor_instance_id" {
  description = "Instance ID of the Data Processor EC2 instance"
  value       = module.ec2_data_processor.instance_id
}

output "data_processor_private_ip" {
  description = "Private IP address of the Data Processor EC2 instance"
  value       = module.ec2_data_processor.private_ip
}

output "data_indexer_instance_id" {
  description = "Instance ID of the Data Indexer EC2 instance"
  value       = module.ec2_data_indexer.instance_id
}

output "data_indexer_private_ip" {
  description = "Private IP address of the Data Indexer EC2 instance"
  value       = module.ec2_data_indexer.private_ip
}

output "archive_bucket_name" {
  description = "Name of the S3 bucket for offline log archives"
  value       = module.s3_archive.bucket_name
}

output "archive_bucket_arn" {
  description = "ARN of the S3 bucket for offline log archives"
  value       = module.s3_archive.bucket_arn
}

output "backup_bucket_name" {
  description = "Name of the S3 bucket for configuration backups"
  value       = module.s3_backup.bucket_name
}

output "backup_bucket_arn" {
  description = "ARN of the S3 bucket for configuration backups"
  value       = module.s3_backup.bucket_arn
}

output "platform_manager_security_group_id" {
  description = "Security group ID for Platform Manager"
  value       = module.security_groups.platform_manager_sg_id
}

output "data_processor_security_group_id" {
  description = "Security group ID for Data Processor"
  value       = module.security_groups.data_processor_sg_id
}

output "data_indexer_security_group_id" {
  description = "Security group ID for Data Indexer"
  value       = module.security_groups.data_indexer_sg_id
}

output "instance_profile_arn" {
  description = "ARN of the IAM instance profile for LogRhythm components"
  value       = module.iam.instance_profile_arn
}
