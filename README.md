## The Architecture, Explained

This repository contains Terraform scripts and instructions for deploying a secure and scalable WordPress instance in a cloud environment, specifically on CSC's OpenStack. The infrastructure consists of two Ubuntu virtual machines: one acting as a web server (VM 1) with Nginx and PHP, and the other (VM-DB) as a MySQL database server. The web server handles HTTP/HTTPS requests, while the database server securely stores WordPress data in a MySQL database, residing in a private subnet for enhanced security. SSL certificates are implemented for encrypted connections.


## Deploying the Cloud Resources Using Terraform

After configuring and validating your cloud provider's account in the providers.tf file, it is time to write the resources and deploy them.

```bash
terraform init
terraform apply
```

## Installation

### MySQL Database Server (VM-DB)

1. Install MySQL on VM-DB:

    ```bash
    sudo apt update
    sudo apt install mysql-server
    sudo systemctl start mysql.service
    ```

2. Configure MySQL:

    ```bash
    sudo mysql
    ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
    exit
    sudo mysql_secure_installation
    ```

    
