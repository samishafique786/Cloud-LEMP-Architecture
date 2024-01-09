# WordPress Deployment with LEMP Architecture

This repository contains Terraform scripts and instructions for deploying a secure and scalable WordPress instance in a cloud environment, specifically on CSC's OpenStack.

## Overview

- **Infrastructure:** Two Ubuntu VMs - one as a web server (VM 1) with Nginx and PHP, and the other (VM-DB) as a MySQL database server.
- **Features:** SSL certificates for encrypted connections, enhanced security with private subnet for the database.

![LEMP-GIT](https://github.com/samishafique786/CloudWordPressDeployment/assets/108603607/55ff980f-03be-4cf8-8303-8cc5b7e61aed)


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

## For complete project setup, follow the instructions on [1-The-LEMP-Architecture.md](https://github.com/samishafique786/CloudWordPressDeployment/blob/main/1-The-LEMP-Architecture.md), [2-MySQL-Configuration.md](https://github.com/samishafique786/CloudWordPressDeployment/blob/main/2-MySQL-Configuration.md), and [3-WordPress-Configuration.md](https://github.com/samishafique786/CloudWordPressDeployment/blob/main/3-WordPress-Configuration.md) respectively. Some of the files are given in the **VM-1 Files** directory in this repository.  
