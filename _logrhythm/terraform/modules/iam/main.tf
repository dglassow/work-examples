# IAM Module for LogRhythm EC2 Instance Profiles and Policies

# IAM Role for LogRhythm EC2 Instances
resource "aws_iam_role" "logrhythm_instance_role" {
  name               = "${var.environment}-logrhythm-instance-role"
  description        = "IAM role for LogRhythm EC2 instances"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = merge(
    {
      Name = "${var.environment}-logrhythm-instance-role"
    },
    var.additional_tags
  )
}

# EC2 Assume Role Policy
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# S3 Access Policy for Archive and Backup Buckets
resource "aws_iam_policy" "s3_access" {
  name        = "${var.environment}-logrhythm-s3-access"
  description = "Policy for LogRhythm instances to access S3 archive and backup buckets"
  policy      = data.aws_iam_policy_document.s3_access.json

  tags = var.additional_tags
}

data "aws_iam_policy_document" "s3_access" {
  statement {
    sid    = "ListBuckets"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:GetBucketVersioning"
    ]
    resources = [
      var.archive_bucket_arn,
      var.backup_bucket_arn
    ]
  }

  statement {
    sid    = "ReadWriteObjects"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:DeleteObject"
    ]
    resources = [
      "${var.archive_bucket_arn}/*",
      "${var.backup_bucket_arn}/*"
    ]
  }

  statement {
    sid    = "ManageObjectTags"
    effect = "Allow"
    actions = [
      "s3:GetObjectTagging",
      "s3:PutObjectTagging"
    ]
    resources = [
      "${var.archive_bucket_arn}/*",
      "${var.backup_bucket_arn}/*"
    ]
  }
}

# CloudWatch Logs Policy
resource "aws_iam_policy" "cloudwatch_logs" {
  name        = "${var.environment}-logrhythm-cloudwatch-logs"
  description = "Policy for LogRhythm instances to write to CloudWatch Logs"
  policy      = data.aws_iam_policy_document.cloudwatch_logs.json

  tags = var.additional_tags
}

data "aws_iam_policy_document" "cloudwatch_logs" {
  statement {
    sid    = "CreateLogStreams"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]
    resources = [
      "arn:aws:logs:*:*:log-group:/aws/logrhythm/*"
    ]
  }
}

# CloudWatch Metrics Policy
resource "aws_iam_policy" "cloudwatch_metrics" {
  name        = "${var.environment}-logrhythm-cloudwatch-metrics"
  description = "Policy for LogRhythm instances to publish custom metrics"
  policy      = data.aws_iam_policy_document.cloudwatch_metrics.json

  tags = var.additional_tags
}

data "aws_iam_policy_document" "cloudwatch_metrics" {
  statement {
    sid    = "PutMetrics"
    effect = "Allow"
    actions = [
      "cloudwatch:PutMetricData"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "cloudwatch:namespace"
      values   = ["LogRhythm/Custom"]
    }
  }
}

# Secrets Manager Policy
resource "aws_iam_policy" "secrets_manager" {
  name        = "${var.environment}-logrhythm-secrets-manager"
  description = "Policy for LogRhythm instances to read secrets"
  policy      = data.aws_iam_policy_document.secrets_manager.json

  tags = var.additional_tags
}

data "aws_iam_policy_document" "secrets_manager" {
  statement {
    sid    = "GetSecrets"
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]
    resources = [
      "arn:aws:secretsmanager:*:*:secret:logrhythm/*"
    ]
  }
}

# Attach Policies to Role
resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.logrhythm_instance_role.name
  policy_arn = aws_iam_policy.s3_access.arn
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs" {
  role       = aws_iam_role.logrhythm_instance_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs.arn
}

resource "aws_iam_role_policy_attachment" "cloudwatch_metrics" {
  role       = aws_iam_role.logrhythm_instance_role.name
  policy_arn = aws_iam_policy.cloudwatch_metrics.arn
}

resource "aws_iam_role_policy_attachment" "secrets_manager" {
  role       = aws_iam_role.logrhythm_instance_role.name
  policy_arn = aws_iam_policy.secrets_manager.arn
}

# Attach AWS Managed SSM Policy
resource "aws_iam_role_policy_attachment" "ssm_managed_instance" {
  role       = aws_iam_role.logrhythm_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance Profile
resource "aws_iam_instance_profile" "logrhythm_profile" {
  name = "${var.environment}-logrhythm-instance-profile"
  role = aws_iam_role.logrhythm_instance_role.name

  tags = var.additional_tags
}
