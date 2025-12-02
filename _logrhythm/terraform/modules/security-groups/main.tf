# Security Groups Module for LogRhythm Components

# Platform Manager Security Group
resource "aws_security_group" "platform_manager" {
  name        = "${var.environment}-logrhythm-platform-manager-sg"
  description = "Security group for LogRhythm Platform Manager"
  vpc_id      = var.vpc_id

  tags = merge(
    {
      Name      = "${var.environment}-logrhythm-platform-manager-sg"
      Component = "platform-manager"
    },
    var.additional_tags
  )
}

# Platform Manager Ingress Rules
resource "aws_vpc_security_group_ingress_rule" "pm_from_dp" {
  security_group_id = aws_security_group.platform_manager.id
  description       = "Allow Data Processor to communicate with Platform Manager"
  
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.data_processor.id
}

resource "aws_vpc_security_group_ingress_rule" "pm_from_di" {
  security_group_id = aws_security_group.platform_manager.id
  description       = "Allow Data Indexer to communicate with Platform Manager"
  
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.data_indexer.id
}

# Platform Manager Egress Rules
resource "aws_vpc_security_group_egress_rule" "pm_to_dp" {
  security_group_id = aws_security_group.platform_manager.id
  description       = "Allow Platform Manager to communicate with Data Processor"
  
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.data_processor.id
}

resource "aws_vpc_security_group_egress_rule" "pm_to_di" {
  security_group_id = aws_security_group.platform_manager.id
  description       = "Allow Platform Manager to communicate with Data Indexer"
  
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.data_indexer.id
}

resource "aws_vpc_security_group_egress_rule" "pm_https_out" {
  security_group_id = aws_security_group.platform_manager.id
  description       = "Allow HTTPS outbound for AWS services"
  
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"
}

# Data Processor Security Group
resource "aws_security_group" "data_processor" {
  name        = "${var.environment}-logrhythm-data-processor-sg"
  description = "Security group for LogRhythm Data Processor"
  vpc_id      = var.vpc_id

  tags = merge(
    {
      Name      = "${var.environment}-logrhythm-data-processor-sg"
      Component = "data-processor"
    },
    var.additional_tags
  )
}

# Data Processor Ingress Rules
resource "aws_vpc_security_group_ingress_rule" "dp_from_pm" {
  security_group_id = aws_security_group.data_processor.id
  description       = "Allow Platform Manager to communicate with Data Processor"
  
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.platform_manager.id
}

resource "aws_vpc_security_group_ingress_rule" "dp_syslog" {
  security_group_id = aws_security_group.data_processor.id
  description       = "Allow syslog traffic from log sources"
  
  from_port   = 514
  to_port     = 514
  ip_protocol = "tcp"
  cidr_ipv4   = var.log_source_cidr
}

resource "aws_vpc_security_group_ingress_rule" "dp_syslog_udp" {
  security_group_id = aws_security_group.data_processor.id
  description       = "Allow syslog UDP traffic from log sources"
  
  from_port   = 514
  to_port     = 514
  ip_protocol = "udp"
  cidr_ipv4   = var.log_source_cidr
}

# Data Processor Egress Rules
resource "aws_vpc_security_group_egress_rule" "dp_to_pm" {
  security_group_id = aws_security_group.data_processor.id
  description       = "Allow Data Processor to communicate with Platform Manager"
  
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.platform_manager.id
}

resource "aws_vpc_security_group_egress_rule" "dp_to_di" {
  security_group_id = aws_security_group.data_processor.id
  description       = "Allow Data Processor to send logs to Data Indexer"
  
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.data_indexer.id
}

resource "aws_vpc_security_group_egress_rule" "dp_https_out" {
  security_group_id = aws_security_group.data_processor.id
  description       = "Allow HTTPS outbound for AWS services"
  
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"
}

# Data Indexer Security Group
resource "aws_security_group" "data_indexer" {
  name        = "${var.environment}-logrhythm-data-indexer-sg"
  description = "Security group for LogRhythm Data Indexer"
  vpc_id      = var.vpc_id

  tags = merge(
    {
      Name      = "${var.environment}-logrhythm-data-indexer-sg"
      Component = "data-indexer"
    },
    var.additional_tags
  )
}

# Data Indexer Ingress Rules
resource "aws_vpc_security_group_ingress_rule" "di_from_pm" {
  security_group_id = aws_security_group.data_indexer.id
  description       = "Allow Platform Manager to communicate with Data Indexer"
  
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.platform_manager.id
}

resource "aws_vpc_security_group_ingress_rule" "di_from_dp" {
  security_group_id = aws_security_group.data_indexer.id
  description       = "Allow Data Processor to send logs to Data Indexer"
  
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.data_processor.id
}

# Data Indexer Egress Rules
resource "aws_vpc_security_group_egress_rule" "di_to_pm" {
  security_group_id = aws_security_group.data_indexer.id
  description       = "Allow Data Indexer to communicate with Platform Manager"
  
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.platform_manager.id
}

resource "aws_vpc_security_group_egress_rule" "di_https_out" {
  security_group_id = aws_security_group.data_indexer.id
  description       = "Allow HTTPS outbound for AWS services and S3"
  
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"
}
