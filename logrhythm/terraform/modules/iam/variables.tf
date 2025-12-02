variable "archive_bucket_arn" {
  description = "ARN of the S3 archive bucket"
  type        = string
}

variable "backup_bucket_arn" {
  description = "ARN of the S3 backup bucket"
  type        = string
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
