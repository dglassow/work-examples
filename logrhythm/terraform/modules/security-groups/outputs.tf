output "platform_manager_sg_id" {
  description = "Security group ID for Platform Manager"
  value       = aws_security_group.platform_manager.id
}

output "data_processor_sg_id" {
  description = "Security group ID for Data Processor"
  value       = aws_security_group.data_processor.id
}

output "data_indexer_sg_id" {
  description = "Security group ID for Data Indexer"
  value       = aws_security_group.data_indexer.id
}
