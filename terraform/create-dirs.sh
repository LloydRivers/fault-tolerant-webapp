# ==============================================================
# Script generated with AI assistance for learning purposes
# All code fully understood and customized by myself.
# Purpose: scaffold Terraform project structure and app folder
# ==============================================================


#!/bin/bash
set -euo pipefail

# Terraform root files
tf_files=("main.tf" "variables.tf" "outputs.tf" "provider.tf")

# Modules and environments
modules=("vpc" "ec2" "alb" "s3" "cloudfront" "route53")
envs=("dev" "staging" "prod")

# App folder files (relative to parent)
# THIS NEXT LINE DID NOT RUN AND THE SCRIPT DID NOT FAIL
app_folder="app"
app_files=("index.html")

# Create Terraform root files
for f in "${tf_files[@]}"; do
  touch "$f"
done

# Create modules folders
for m in "${modules[@]}"; do
  mkdir -p "modules/$m"
done

# Create environments folders and tfvars files
for e in "${envs[@]}"; do
  mkdir -p "environments/$e"
  touch "environments/$e/terraform.tfvars"
done

# Create app folder and files
mkdir -p "$app_folder"
for f in "${app_files[@]}"; do
  touch "$app_folder/$f"
done

echo "Terraform folder structure and app folder created successfully!"
