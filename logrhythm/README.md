# LogRhythm SIEM Infrastructure Automation

Infrastructure as Code (IaC) and automation scripts for managing LogRhythm Security Information and Event Management (SIEM) platform on AWS.

## Overview

The LogRhythm infrastructure consists of three EC2 instances deployed on AWS:
- **Platform Manager** (Windows) - Central management console and database
- **Data Processor** (Windows) - Log collection, parsing, and processing
- **Data Indexer** (Rocky Linux) - Log indexing and search capabilities

Includes:
- **Terraform IaC** for infrastructure management
- **Import scripts** to bring existing resources under Terraform control
- **Management scripts** for operational automation (archival, service management, metrics)
- **Health check scripts** for proactive monitoring
- **Backup automation** for disaster recovery and compliance

## Repository Structure

```
logrhythm/
├── README.md                    # This file
├── documentation/               # Specification documents
│   ├── requirements.md          # Feature requirements
│   ├── design.md                # Technical design
│   └── tasks.md                 # Implementation plan
├── terraform/                   # Terraform IaC
│   ├── main.tf                  # Root module
│   ├── variables.tf             # Input variables
│   ├── outputs.tf               # Outputs
│   ├── backend.tf               # S3 backend config
│   ├── versions.tf              # Provider versions
│   ├── modules/                 # Reusable modules
│   │   ├── ec2-logrhythm/       # EC2 instance module
│   │   ├── s3-archive/          # S3 bucket module
│   │   ├── security-groups/     # Security group module
│   │   └── iam/                 # IAM roles and policies
│   ├── environments/            # Environment configs
│   │   └── production/
│   └── README.md                # Terraform documentation
└── scripts/                     # Automation scripts (to be implemented)
    ├── import/                  # Resource import scripts
    ├── management/              # Operational scripts
    ├── health/                  # Health check scripts
    └── backup/                  # Backup automation
```

## Quick Start

### Prerequisites

- **Terraform** >= 1.5.0
- **Python** >= 3.9
- **AWS CLI** >= 2.0
- **Boto3** >= 1.28.0
- AWS account with appropriate permissions

### Initial Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd logrhythm
   ```

2. **Create backend resources** (S3 bucket and DynamoDB table)
   ```bash
   # Full commands in terraform/README.md
   aws s3api create-bucket --bucket [organization]-terraform-state --region us-east-1
   aws dynamodb create-table --table-name terraform-state-lock ...
   ```

3. **Configure environment variables**
   ```bash
   cd terraform
   # Edit environments/production/terraform.tfvars with your values
   ```

4. **Initialize Terraform**
   ```bash
   terraform init -backend-config=environments/production/backend.tfvars
   ```

5. **Review and apply**
   ```bash
   terraform plan -var-file=environments/production/terraform.tfvars
   terraform apply -var-file=environments/production/terraform.tfvars
   ```

## Documentation

### Specification Documents

Located in `documentation/`:

- **[requirements.md](documentation/requirements.md)** - Requirements using EARS format with acceptance criteria
- **[design.md](documentation/design.md)** - Technical architecture, component design, data models, and testing strategy
- **[tasks.md](documentation/tasks.md)** - Implementation task list with progress tracking

### Terraform Documentation

See [terraform/README.md](terraform/README.md) for:
- Module documentation
- Usage examples
- Configuration options
- Troubleshooting guide

## Features

### Infrastructure as Code (Terraform)

- **Modular design** with reusable components
- **State management** with S3 backend and DynamoDB locking
- **Encrypted resources** (EBS volumes, S3 buckets)
- **Least-privilege IAM** roles and policies
- **Standardized tagging** for cost tracking and compliance

### Import Scripts (Planned)

- Discover existing AWS resources by tags
- Generate Terraform configuration from current state
- Import resources into Terraform state
- Validate zero-drift after import

### Management Automation (Planned)

- **Log archival** - Automated transfer of inactive logs to S3
- **Service management** - Controlled restart sequences
- **Metrics collection** - Custom CloudWatch metrics for monitoring

### Health Monitoring (Planned)

- Service status checks for all components
- Disk space monitoring with configurable thresholds
- Connectivity validation between components
- SNS alerting with severity classification

### Backup Automation (Planned)

- Daily backups of LogRhythm configurations
- SQL Server database backups
- S3 storage with lifecycle policies (30-day standard, then Glacier)
- Backup integrity verification

## AWS Resources Managed

### Compute
- 3x EC2 instances (Platform Manager, Data Processor, Data Indexer)
- IAM instance profiles and roles
- Security groups with inter-component rules

### Storage
- S3 bucket for offline log archives
- S3 bucket for configuration backups
- EBS volumes (encrypted)

### Monitoring & Logging
- CloudWatch Log Groups
- CloudWatch custom metrics
- SNS topics for alerting

### Security
- AWS Secrets Manager for credentials
- IAM policies following least-privilege
- Encrypted data at rest and in transit

## Configuration

### Terraform Variables

Key variables in `terraform/variables.tf`:

- `aws_region` - AWS region (default: us-east-1)
- `environment` - Environment name (production, staging, etc.)
- `vpc_id` - VPC ID for deployment
- `subnet_ids` - Subnet IDs for each component
- `*_config` - Instance configurations (type, AMI, volume size)
- `archive_bucket_name` - S3 bucket for log archives
- `backup_bucket_name` - S3 bucket for backups

### Script Configuration (Planned)

Scripts will use YAML configuration files:

```yaml
# config/logrhythm_automation.yaml
aws:
  region: us-east-1

logrhythm:
  platform_manager:
    instance_id: INSTANCE_ID
    hostname: logrhythm-pm.internal
  
s3:
  archive_bucket: [organization]-logrhythm-archive
  backup_bucket: [organization]-logrhythm-backups

cloudwatch:
  log_group: /aws/logrhythm/automation
```

## Security Considerations

- **Encryption**: All EBS volumes and S3 buckets use encryption
- **IAM**: Least-privilege policies for all roles
- **Secrets**: Credentials stored in AWS Secrets Manager
- **Network**: Security groups restrict traffic to minimum required
- **Compliance**: Designed to support SOC2 and regulatory requirements

## Operational Procedures

### Importing Existing Infrastructure

1. Run import scripts to discover resources
2. Review generated Terraform configuration
3. Execute import commands
4. Validate with `terraform plan` (should show zero changes)

### Making Infrastructure Changes

1. Update Terraform configuration
2. Run `terraform plan` to review changes
3. Get peer review and approval
4. Apply changes with `terraform apply`
5. Verify changes in AWS console

### Backup and Recovery

1. Backups run daily via EventBridge schedules
2. Backups stored in S3 with 30-day retention
3. Recovery procedures documented in runbooks
4. RTO: 4 hours, RPO: 24 hours

### Health Monitoring

1. Health checks run every 5 minutes
2. Alerts sent via SNS based on severity
3. Critical alerts: Service down, disk >95%
4. Warning alerts: Disk 80-95%, performance issues

## Development Workflow

### Working with Specs

This project follows spec-driven development:

1. **Requirements** - Define what needs to be built
2. **Design** - Plan the technical approach
3. **Tasks** - Break down into implementation steps
4. **Execute** - Implement tasks incrementally

Track progress in `documentation/tasks.md`.

### Contributing

1. Create a feature branch
2. Make changes following the design document
3. Test in non-production environment
4. Submit pull request with description
5. Get peer review
6. Merge after approval

## Troubleshooting

### Terraform Issues

**State locked:**
```bash
terraform force-unlock <LOCK_ID>
```

**Backend initialization fails:**
```bash
terraform init -reconfigure -backend-config=environments/production/backend.tfvars
```

**Module not found:**
Ensure you're in the `terraform/` directory.

### AWS Permission Issues

Verify your AWS credentials have permissions for:
- EC2 (instances, volumes, security groups)
- S3 (buckets, objects)
- IAM (roles, policies)
- CloudWatch (logs, metrics)
- Secrets Manager
- Systems Manager

## Monitoring and Alerting

### CloudWatch Dashboards

- EC2 instance metrics (CPU, memory, disk, network)
- Script execution status and duration
- Backup success/failure rates
- Health check status over time

### SNS Topics

- **Critical**: `logrhythm-critical` - Service failures, disk >95%
- **Warning**: `logrhythm-warning` - Disk 80-95%, degraded performance

## Disaster Recovery

### Recovery Procedures

1. Provision new EC2 instances using Terraform
2. Restore configurations from S3 backups
3. Restore LogRhythm databases
4. Validate connectivity and functionality
5. Resume log processing

### Recovery Objectives

- **RTO** (Recovery Time Objective): 4 hours
- **RPO** (Recovery Point Objective): 24 hours

## Compliance

This infrastructure supports:
- SOC2 compliance requirements
- Data retention policies
- Audit logging and traceability
- Encryption at rest and in transit
- Access control and least privilege

## Support and Contact

- **Team**: Security Operations
- **Email**: [security-team-email]
- **Documentation**: See `documentation/` directory
- **Issues**: Track in project management system

## License

Internal use only

## Changelog

### Version 1.0.0 (In Progress)

- Initial Terraform infrastructure setup
- Module structure for EC2, S3, security groups, and IAM
- Backend configuration with S3 and DynamoDB
- Documentation and specifications

### Planned Features

- Import scripts for existing resources
- Management automation scripts
- Health check automation
- Backup automation
- CloudWatch dashboards
- Operational runbooks

## References

- [AWS Best Practices](https://aws.amazon.com/architecture/well-architected/)
- [Terraform Documentation](https://www.terraform.io/docs)
- [LogRhythm Documentation](https://docs.logrhythm.com/)
- [NIST 800-53 Controls](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final)
- [CIS AWS Benchmarks](https://www.cisecurity.org/benchmark/amazon_web_services)
