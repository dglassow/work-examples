# LogRhythm SIEM Terraform Infrastructure

Terraform Infrastructure as Code (IaC) for managing LogRhythm SIEM deployment on AWS.

## Directory Structure

```
terraform/
├── backend.tf              # S3 backend configuration
├── versions.tf             # Terraform and provider version requirements
├── variables.tf            # Root module input variables
├── outputs.tf              # Root module outputs
├── main.tf                 # Root module orchestration
├── modules/                # Reusable Terraform modules
│   ├── ec2-logrhythm/      # EC2 instance module for LogRhythm components
│   ├── s3-archive/         # S3 bucket module for archives and backups
│   ├── security-groups/    # Security group module
│   └── iam/                # IAM roles and policies module
└── environments/           # Environment-specific configurations
    └── production/
        ├── terraform.tfvars    # Production variable values
        └── backend.tfvars      # Production backend configuration
```

## Prerequisites

Before using this Terraform configuration, ensure you have:

1. **Terraform** >= 1.5.0 installed
2. **AWS CLI** >= 2.0 configured with appropriate credentials
3. **AWS Account** with permissions to create:
   - EC2 instances
   - S3 buckets
   - IAM roles and policies
   - Security groups
   - DynamoDB tables (for state locking)

## Initial Setup

### 1. Create Backend Resources

Before initializing Terraform, create the S3 bucket and DynamoDB table for state management:

```bash
# Create S3 bucket for Terraform state
aws s3api create-bucket \
  --bucket [organization]-terraform-state \
  --region us-east-1

# Enable versioning on the state bucket
aws s3api put-bucket-versioning \
  --bucket [organization]-terraform-state \
  --versioning-configuration Status=Enabled

# Enable encryption on the state bucket
aws s3api put-bucket-encryption \
  --bucket [organization]-terraform-state \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }]
  }'

# Create DynamoDB table for state locking
aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```

### 2. Configure Environment Variables

Update `environments/production/terraform.tfvars` with your actual values:

- VPC ID
- Subnet IDs for each component
- AMI IDs for Windows and Rocky Linux
- Instance types and sizes
- S3 bucket names (must be globally unique)
- Tags and metadata

### 3. Initialize Terraform

```bash
cd terraform

# Initialize with production backend configuration
terraform init -backend-config=environments/production/backend.tfvars
```

## Usage

### Plan Changes

Review changes before applying:

```bash
terraform plan -var-file=environments/production/terraform.tfvars
```

### Apply Changes

Apply the Terraform configuration:

```bash
terraform apply -var-file=environments/production/terraform.tfvars
```

### Destroy Resources

**WARNING**: This will destroy all managed infrastructure!

```bash
terraform destroy -var-file=environments/production/terraform.tfvars
```

## Modules

### ec2-logrhythm

Creates EC2 instances for LogRhythm components with:
- Encrypted EBS root volumes
- IAM instance profiles
- Security group attachments
- Standardized tagging

**Inputs:**
- `component_name`: Name of the LogRhythm component
- `instance_type`: EC2 instance type
- `ami_id`: AMI ID for the instance
- `subnet_id`: Subnet ID for deployment
- `security_group_ids`: List of security group IDs
- `instance_profile_name`: IAM instance profile name
- `root_volume_size`: Size of root volume in GB

**Outputs:**
- `instance_id`: EC2 instance ID
- `private_ip`: Private IP address
- `availability_zone`: AZ where instance is deployed

### s3-archive

Creates S3 buckets for log archives and backups with:
- Versioning enabled
- Server-side encryption (AES256)
- Lifecycle policies for Glacier transition
- Public access blocking
- Secure transport enforcement

**Inputs:**
- `bucket_name`: Name of the S3 bucket
- `lifecycle_glacier_days`: Days before transitioning to Glacier

**Outputs:**
- `bucket_name`: S3 bucket name
- `bucket_arn`: S3 bucket ARN

### security-groups

Creates security groups for LogRhythm components with:
- Inter-component communication rules
- Syslog ingress for Data Processor
- HTTPS egress for AWS services
- Least-privilege access patterns

**Inputs:**
- `vpc_id`: VPC ID for security groups
- `log_source_cidr`: CIDR block for log sources

**Outputs:**
- `platform_manager_sg_id`: Platform Manager security group ID
- `data_processor_sg_id`: Data Processor security group ID
- `data_indexer_sg_id`: Data Indexer security group ID

### iam

Creates IAM roles and policies for LogRhythm instances with:
- S3 access for archives and backups
- CloudWatch Logs and Metrics permissions
- Secrets Manager read access
- SSM managed instance core permissions

**Inputs:**
- `archive_bucket_arn`: ARN of archive S3 bucket
- `backup_bucket_arn`: ARN of backup S3 bucket

**Outputs:**
- `instance_role_arn`: IAM role ARN
- `instance_profile_name`: Instance profile name

## Outputs

After applying, Terraform will output:

- Instance IDs and private IPs for all three components
- S3 bucket names and ARNs
- Security group IDs
- IAM instance profile ARN

Access outputs:

```bash
terraform output
terraform output platform_manager_instance_id
```

## State Management

Terraform state is stored in S3 with:
- **Bucket**: `[organization]-terraform-state`
- **Key**: `logrhythm/production/terraform.tfstate`
- **Encryption**: Enabled (AES256)
- **Versioning**: Enabled
- **Locking**: DynamoDB table `terraform-state-lock`

## Best Practices

1. **Always run `terraform plan`** before applying changes
2. **Use workspaces** for multiple environments (dev, staging, prod)
3. **Review state file** after imports to ensure accuracy
4. **Never commit** `terraform.tfvars` with sensitive values to version control
5. **Use remote state** for team collaboration
6. **Tag all resources** consistently for cost tracking and management

## Importing Existing Resources

Import existing AWS resources into Terraform state using the import scripts in `../scripts/import/`.

## Troubleshooting

### State Lock Issues

If Terraform state is locked:

```bash
# Force unlock (use with caution)
terraform force-unlock <LOCK_ID>
```

### Backend Initialization Errors

If backend initialization fails:

```bash
# Reconfigure backend
terraform init -reconfigure -backend-config=environments/production/backend.tfvars
```

### Module Not Found Errors

Ensure you're running Terraform from the `terraform/` directory and modules exist in `modules/`.

## Security Considerations

- All EBS volumes are encrypted
- S3 buckets enforce encryption in transit and at rest
- IAM policies follow least-privilege principles
- Security groups restrict traffic to minimum required
- Secrets should be stored in AWS Secrets Manager, not in Terraform

## Support

Questions or issues:
- Design document: `../documentation/design.md`
- Requirements: `../documentation/requirements.md`
- Contact: [security-team-email]
