# EC2 Instance Module for LogRhythm Components
# This module creates EC2 instances for Platform Manager, Data Processor, or Data Indexer

resource "aws_instance" "logrhythm_component" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile   = var.instance_profile_name

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
    encrypted             = true
    delete_on_termination = false
    
    tags = {
      Name = "${var.hostname}-root-volume"
    }
  }

  user_data = var.user_data

  tags = merge(
    {
      Name      = var.hostname
      Component = var.component_name
    },
    var.additional_tags
  )

  lifecycle {
    ignore_changes = [
      ami,
      user_data,
    ]
  }
}
