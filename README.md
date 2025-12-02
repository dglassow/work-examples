# DevOps & Infrastructure Portfolio

This repository contains sanitized examples of production infrastructure code and automation scripts I've developed. All sensitive information, credentials, and proprietary details have been removed or replaced with generic placeholders.

## Overview

These examples demonstrate practical experience with:

- **Container Orchestration**: Docker and Docker Compose configurations for multi-service applications
- **CI/CD Pipelines**: GitHub Actions workflows with automated builds, security scanning, and deployment
- **Infrastructure as Code**: Terraform modules for AWS resource provisioning
- **Automation Scripts**: Bash scripts for database operations, webhooks, and deployment automation
- **Cloud Services**: AWS ECR, EC2, S3, IAM, and related services


## Repository Structure

### `/containers`
Production-ready Docker configurations for a PHP/Laravel application stack including:
- Multi-stage Dockerfile with PHP 8.4-FPM, Composer, and Rust toolchain
- Docker Compose orchestration for app, database, web server, queue workers, and supporting services
- Optimized caching and build strategies

### `/gh-actions`
Enterprise-grade CI/CD pipeline featuring:
- Automated Docker image builds with layer caching
- Multi-environment deployment support (dev/staging/production)
- Security scanning with Trivy
- Automated rollback on deployment failure
- Concurrency controls and health checks

### `/bash-examples`
Operational automation scripts including:
- Database-driven webhook integrations
- Automated deployment and service management
- Complex data processing and game logic automation

### `/go`
Go-based automation and scripting:
- Game automation logic with build queue management
- Error handling and retry mechanisms
- State management and conditional logic
- API integration patterns

### `/logrhythm`
Terraform infrastructure for log management and SIEM deployment:
- Modular architecture with reusable components
- EC2 instance provisioning with proper IAM roles
- S3 archival storage configuration
- Security group management

## Technical Highlights

**Security Best Practices**
- OIDC authentication for AWS
- Automated vulnerability scanning
- Secrets management via environment variables
- Principle of least privilege in IAM policies

**Performance Optimization**
- Docker BuildKit with multi-stage builds
- Layer caching strategies
- Optimized image sizes
- Resource-efficient container configurations

**Reliability & Observability**
- Health check implementations
- Automated rollback mechanisms
- Structured logging
- Deployment tracking and metrics

**Professional Standards**
- Clean, maintainable code
- Comprehensive error handling
- Documentation and comments
- Version control best practices

## Technologies

- **Containers**: Docker, Docker Compose
- **CI/CD**: GitHub Actions
- **Cloud**: AWS (ECR, EC2, S3, IAM)
- **IaC**: Terraform
- **Languages**: Go, Bash, YAML, HCL
- **Databases**: PostgreSQL, MariaDB, Redis
- **Web Stack**: PHP 8.4, Laravel, Nginx

## Notes

All code samples have been sanitized for public sharing. Database credentials, API keys, webhook URLs, AWS account IDs, and project-specific naming have been replaced with generic placeholders. These examples represent real production code adapted for portfolio purposes.

---

*This repository serves as a demonstration of DevOps engineering capabilities and infrastructure automation expertise.*
