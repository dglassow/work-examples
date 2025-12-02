variable "vpc_id" {
  description = "VPC ID where security groups will be created"
  type        = string
}

variable "log_source_cidr" {
  description = "CIDR block for log sources that send syslog to Data Processor"
  type        = string
  default     = "10.0.0.0/8"
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "cost_center" {
  description = "Cost center for tagging"
  type        = string
}

variable "owner" {
  description = "Owner for tagging"
  type        = string
}

variable "additional_tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}
