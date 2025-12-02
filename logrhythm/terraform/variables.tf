variable "aws_region" {
  description = "AWS region for LogRhythm infrastructure"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (e.g., production, staging, development)"
  type        = string
  default     = "production"
}

variable "vpc_id" {
  description = "VPC ID where LogRhythm components are deployed"
  type        = string
}

variable "subnet_ids" {
  description = "Map of subnet IDs for each LogRhythm component"
  type = map(string)
  default = {
    platform_manager = ""
    data_processor   = ""
    data_indexer     = ""
  }
}

# Platform Manager Configuration
variable "platform_manager_config" {
  description = "Configuration for Platform Manager EC2 instance"
  type = object({
    instance_type    = string
    ami_id           = string
    root_volume_size = number
    hostname         = string
  })
  default = {
    instance_type    = "t3.large"
    ami_id           = ""
    root_volume_size = 100
    hostname         = "logrhythm-pm"
  }
}

# Data Processor Configuration
variable "data_processor_config" {
  description = "Configuration for Data Processor EC2 instance"
  type = object({
    instance_type    = string
    ami_id           = string
    root_volume_size = number
    hostname         = string
  })
  default = {
    instance_type    = "t3.large"
    ami_id           = ""
    root_volume_size = 100
    hostname         = "logrhythm-dp"
  }
}

# Data Indexer Configuration
variable "data_indexer_config" {
  description = "Configuration for Data Indexer EC2 instance"
  type = object({
    instance_type    = string
    ami_id           = string
    root_volume_size = number
    hostname         = string
  })
  default = {
    instance_type    = "t3.large"
    ami_id           = ""
    root_volume_size = 200
    hostname         = "logrhythm-di"
  }
}

# S3 Configuration
variable "archive_bucket_name" {
  description = "Name of the S3 bucket for offline log archives"
  type        = string
  default     = "[organization]-logrhythm-archive"
}

variable "backup_bucket_name" {
  description = "Name of the S3 bucket for configuration backups"
  type        = string
  default     = "[organization]-logrhythm-backups"
}

variable "archive_lifecycle_glacier_days" {
  description = "Number of days before transitioning archive logs to Glacier"
  type        = number
  default     = 90
}

# Tagging
variable "cost_center" {
  description = "Cost center for resource tagging"
  type        = string
  default     = "Security-Operations"
}

variable "owner" {
  description = "Owner email or team for resource tagging"
  type        = string
  default     = "[security-team-email]"
}

variable "additional_tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
