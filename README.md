# WordPress Deployment with LEMP Architecture

This repository contains Terraform scripts and instructions for deploying a secure and scalable WordPress instance in a cloud environment, specifically on CSC's OpenStack.

## Overview

- **Infrastructure:** Two Ubuntu VMs - one as a web server (VM 1) with Nginx and PHP, and the other (VM-DB) as a MySQL database server.
- **Features:** SSL certificates for encrypted connections, enhanced security with private subnet for the database.

## Deployment

1. Configure your cloud provider's account in `providers.tf`.
2. Deploy resources using Terraform:

   ```bash
   terraform init
   terraform apply
   ```
### MySQL Database Setup (VM-DB)

Install MySQL on VM-DB.
Configure MySQL for enhanced security.
### Web Server Setup (VM-1) with Nginx and PHP
Install NGINX, PHP, and configure Nginx for optimal performance.
Test your NGINX configuration.
### MySQL Configuration on VM-2
Configure MySQL on VM-2 for remote connections.
Set up WordPress database and remote credentials.
### WordPress Installation (VM-1)
Install PHP extensions for WordPress.
Install and configure WordPress.
Adjust Nginx server block for WordPress performance.
### SSL Certificate Setup for Nginx
Generate a self-signed SSL certificate.
Configure NGINX to use SSL.
Adjust Nginx configuration for SSL.
