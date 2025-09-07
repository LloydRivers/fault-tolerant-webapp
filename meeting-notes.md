# AWS Architecture Guide: Fault-Tolerant Web Application

> Meeting notes with Nitesh - refined and organized for implementation

## Architecture Overview

This document outlines a fault-tolerant, cost-effective AWS architecture for hosting a web application with high availability, security, and performance optimization.

---

## 🏗️ Core Infrastructure Components

### 1. EC2 Compute Layer

Our compute foundation uses AWS EC2 instances configured for fault tolerance and cost efficiency.

**Architecture Decision:**
- **Instance Type**: `t3.micro` or `t4g.micro` (1 vCPU, 1GB RAM)
- **Deployment**: Auto Scaling Group with Launch Template (not single instance)
- **Cost Optimization**: Right-sized instances with horizontal scaling capability

**Terraform Resources:**
```hcl
# Primary resources needed
aws_launch_template
aws_autoscaling_group
# Alternative: aws_instance (single instance - not recommended)
```

**Key Considerations:**
- Private subnet placement for enhanced security
- Launch template defines instance configuration for ASG

---

### 2. Application Load Balancer (ALB) with Health Monitoring

The ALB serves as our traffic distribution and health management layer.

**Features:**
- **Traffic Distribution**: Routes requests across healthy EC2 instances
- **Health Checks**: Continuous monitoring with automatic traffic rerouting
- **Protocol Support**: HTTP/HTTPS with SSL termination

**Terraform Resources:**
```hcl
aws_lb                 # The load balancer itself
aws_lb_target_group    # Defines backend targets
aws_lb_listener        # Handles incoming requests
```

**Health Check Configuration:**
- Protocol, path, and interval settings
- Automatic unhealthy instance removal from rotation

---

### 3. Auto Scaling for High Availability

Ensures application resilience through automatic instance management.

**Capabilities:**
- **Instance Replacement**: Automatic recovery from instance failures
- **Traffic Management**: Seamless rerouting via ALB integration
- **Capacity Planning**: Configurable min/max/desired instance counts

**Terraform Resources:**
```hcl
aws_autoscaling_group   # Core scaling functionality
aws_launch_template     # Instance configuration template
```

**Benefits:**
- Zero-downtime deployments
- Automatic fault recovery
- Cost-effective horizontal scaling

---

## 💾 Storage & Content Delivery

### 4. S3 for Asset Storage

Durable, scalable storage for web assets and user-generated content.

**Use Cases:**
- Web application images and media
- Static assets and documents
- User uploads and generated content

**Terraform Resources:**
```hcl
aws_s3_bucket           # Primary storage bucket
aws_s3_bucket_policy    # Access permissions
aws_s3_bucket_object    # Pre-loaded static assets (optional)
```

**Integration:**
- AWS SDK/CLI integration for application access
- Separation from ephemeral EC2 storage

---

### 5. CloudFront CDN (Optional Enhancement)

Global content delivery network for performance optimization.

**Benefits:**
- **Global Caching**: Reduced latency worldwide
- **Load Reduction**: Decreased EC2/S3 traffic
- **HTTPS Support**: SSL/TLS with ACM certificates

**Terraform Resources:**
```hcl
aws_cloudfront_distribution
```

**Origins Configuration:**
- S3 bucket for static assets
- ALB for dynamic content
- Route53 domain integration

---

## 🔒 Security & Networking

### 6. Virtual Private Cloud (VPC) Architecture

Isolated network environment with strategic subnet design.

**Network Design:**
- **Public Subnet**: ALB placement for internet access
- **Private Subnet**: EC2 instances for enhanced security
- **Connectivity**: Internet Gateway and NAT Gateway for controlled access

**Terraform Resources:**
```hcl
aws_vpc                 # Virtual private cloud
aws_subnet             # Public and private subnets
aws_internet_gateway   # Internet access
aws_nat_gateway        # Outbound internet for private subnets
aws_route_table        # Traffic routing rules
```

---

### 7. Private Subnet EC2 Deployment

Enhanced security through network isolation.

**Security Benefits:**
- No public IP addresses on application servers
- ALB-only external access
- Reduced attack surface

**Requirements:**
- NAT Gateway for internet access (updates, dependencies)
- Systems Manager for administrative access

---

### 8. Systems Manager Access

Secure administrative access without SSH keys or public IPs.

**Features:**
- **Session Manager**: Browser-based terminal access
- **No SSH Keys**: Enhanced security model
- **Audit Trail**: Complete session logging

**Terraform Resources:**
```hcl
aws_iam_role              # EC2 service role
aws_iam_instance_profile  # Role attachment mechanism
```

**Required Permissions:**
- SSM core permissions for session management
- CloudWatch logging for audit trails

---

## 🌐 Domain & SSL Management

### 9. Route53 DNS Management

Professional domain routing and DNS management.

**Configuration:**
- **Hosted Zone**: Domain authority delegation
- **Record Sets**: Traffic routing to ALB or CloudFront
- **DNS Outputs**: Terraform-managed domain references

**Terraform Resources:**
```hcl
aws_route53_zone    # DNS hosted zone
aws_route53_record  # Domain routing records
```

---

### 10. Certificate Manager SSL

Free, managed SSL/TLS certificates for HTTPS.

**Features:**
- **Automatic Renewal**: Zero-maintenance certificates
- **ALB Integration**: SSL termination at load balancer
- **Domain Validation**: Automated certificate issuance

**Implementation:**
- ALB listener references certificate ARN
- Internal EC2 traffic remains HTTP
- CloudFront integration for global SSL

---

## 📊 Architecture Summary

This architecture provides:

- ✅ **High Availability**: Auto Scaling Group with multi-AZ deployment
- ✅ **Cost Efficiency**: Right-sized instances (1 vCPU, 1GB RAM)
- ✅ **Security**: Private subnets with Systems Manager access
- ✅ **Performance**: ALB health checks and optional CloudFront CDN
- ✅ **Scalability**: Horizontal scaling with load balancing
- ✅ **Professional**: SSL certificates and custom domain routing

---

## 🎯 Next Steps

Consider creating a comprehensive Mermaid diagram showing:
- Network topology (VPC, subnets, routing)
- Service relationships (ALB → ASG → EC2)
- Data flows (CloudFront → S3, Route53 → ALB)
- Security boundaries and access patterns

This architecture provides enterprise-grade reliability while maintaining cost efficiency through smart resource sizing and AWS managed services.