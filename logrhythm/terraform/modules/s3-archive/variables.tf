variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "lifecycle_glacier_days" {
  description = "Number of days before transitioning objects to Glacier storage class"
  type        = number
  default     = 90
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
