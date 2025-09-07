# Fault-Tolerant Web Application on AWS

This project demonstrates a fully fault-tolerant web application deployed on AWS using both Terraform and CloudFormation. The application is designed for high availability, security, and performance, following industry best practices.

## Features

- Hosted on EC2 instances within a private subnet
- Autoscaling Group ensures application remains available
- Application Load Balancer with health checks
- S3 bucket for storing static assets (images, files)
- SSL/TLS managed via AWS Certificate Manager (ACM)
- CloudFront CDN for caching and performance
- Route53 for DNS management
- VPC with private/public subnets, NAT gateways, and security groups
- Full Infrastructure-as-Code for repeatable deployments
