# LogRhythm SIEM Infrastructure
# This root module orchestrates all LogRhythm infrastructure components

# IAM Module - Create roles and policies first
module "iam" {
  source = "./modules/iam"

  environment        = var.environment
  archive_bucket_arn = module.s3_archive.bucket_arn
  backup_bucket_arn  = module.s3_backup.bucket_arn
  cost_center        = var.cost_center
  owner              = var.owner
  additional_tags    = var.additional_tags
}

# Security Groups Module
module "security_groups" {
  source = "./modules/security-groups"

  vpc_id          = var.vpc_id
  environment     = var.environment
  cost_center     = var.cost_center
  owner           = var.owner
  additional_tags = var.additional_tags
}

# S3 Archive Bucket Module
module "s3_archive" {
  source = "./modules/s3-archive"

  bucket_name              = var.archive_bucket_name
  lifecycle_glacier_days   = var.archive_lifecycle_glacier_days
  environment              = var.environment
  cost_center              = var.cost_center
  owner                    = var.owner
  additional_tags          = var.additional_tags
}

# S3 Backup Bucket Module
module "s3_backup" {
  source = "./modules/s3-archive"

  bucket_name              = var.backup_bucket_name
  lifecycle_glacier_days   = 30
  environment              = var.environment
  cost_center              = var.cost_center
  owner                    = var.owner
  additional_tags          = merge(var.additional_tags, { Purpose = "ConfigBackups" })
}

# Platform Manager EC2 Instance
module "ec2_platform_manager" {
  source = "./modules/ec2-logrhythm"

  component_name       = "platform-manager"
  instance_type        = var.platform_manager_config.instance_type
  ami_id               = var.platform_manager_config.ami_id
  subnet_id            = var.subnet_ids["platform_manager"]
  security_group_ids   = [module.security_groups.platform_manager_sg_id]
  instance_profile_name = module.iam.instance_profile_name
  root_volume_size     = var.platform_manager_config.root_volume_size
  hostname             = var.platform_manager_config.hostname
  environment          = var.environment
  cost_center          = var.cost_center
  owner                = var.owner
  additional_tags      = var.additional_tags
}

# Data Processor EC2 Instance
module "ec2_data_processor" {
  source = "./modules/ec2-logrhythm"

  component_name       = "data-processor"
  instance_type        = var.data_processor_config.instance_type
  ami_id               = var.data_processor_config.ami_id
  subnet_id            = var.subnet_ids["data_processor"]
  security_group_ids   = [module.security_groups.data_processor_sg_id]
  instance_profile_name = module.iam.instance_profile_name
  root_volume_size     = var.data_processor_config.root_volume_size
  hostname             = var.data_processor_config.hostname
  environment          = var.environment
  cost_center          = var.cost_center
  owner                = var.owner
  additional_tags      = var.additional_tags
}

# Data Indexer EC2 Instance
module "ec2_data_indexer" {
  source = "./modules/ec2-logrhythm"

  component_name       = "data-indexer"
  instance_type        = var.data_indexer_config.instance_type
  ami_id               = var.data_indexer_config.ami_id
  subnet_id            = var.subnet_ids["data_indexer"]
  security_group_ids   = [module.security_groups.data_indexer_sg_id]
  instance_profile_name = module.iam.instance_profile_name
  root_volume_size     = var.data_indexer_config.root_volume_size
  hostname             = var.data_indexer_config.hostname
  environment          = var.environment
  cost_center          = var.cost_center
  owner                = var.owner
  additional_tags      = var.additional_tags
}
