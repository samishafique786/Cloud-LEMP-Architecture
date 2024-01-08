## The LEMP Architecture, Explained

This repository contains Terraform scripts and instructions for deploying a secure and scalable WordPress instance in a cloud environment, specifically on CSC's OpenStack. The infrastructure consists of two Ubuntu virtual machines: one acting as a web server (VM 1) with Nginx and PHP, and the other (VM-DB) as a MySQL database server. The web server handles HTTP/HTTPS requests, while the database server securely stores WordPress data in a MySQL database, residing in a private subnet for enhanced security. SSL certificates are implemented for encrypted connections.


## Deploying the Cloud Resources Using Terraform

After configuring and validating your cloud provider's account in the providers.tf file, it is time to write the resources and deploy them.

```bash
terraform init
terraform apply
```

## Installation 1 (VM-DB)

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

## Installation 2 (VM-1)

### Web Server Setup with Nginx and PHP on VM-1

Nginx serves as a versatile web server, capable of functioning as a reverse proxy, load balancer, mail proxy, and HTTP cache. Let us outline the installation process of **Nginx** and **PHP** on a **Virtual Machine (VM-1)** running Ubuntu 20.04, with specific refinements and considerations.

1. Install NGINX

   ```bash
   sudo apt update
   sudo apt install nginx
   ```

2. Install PHP & PHP MySQL

Install **php-fpm** for PHP processing with Nginx, and add **php-mysql** for PHP to interact with MySQL databases. (since we will configure PHP to store and get data from the Database server in the private network)

```bash
sudo apt install php-fpm php-mysql
```
###  Configuring Nginx to Use the PHP Processor (VM-1)

```bash
# Create web root directory
sudo mkdir /var/www/<your_domain>

# Set ownership
sudo chown -R $USER:$USER /var/www/<your_domain>

# Create Nginx server block configuration
sudo nano /etc/nginx/sites-available/<your_domain>
# paste the contents of the "your_domain" file (you can find it in the files directory of this repo.
```

Now that you have written the NGINX configuration, it is time to activate these configurations. You do that by linking to the config file from Nginx’s sites-enabled directory:
```bash
sudo ln -s /etc/nginx/sites-available/your_domain /etc/nginx/sites-enabled/
```
Then, unlink the default NGINX configuration
```bash
sudo unlink /etc/nginx/sites-enabled/default
```

Wanna check your new NGINX configuration for syntax errors?
```bash
sudo nginx -t
```
Time to reload NGINX for applying the new configurations
```bash
sudo systemctl reload nginx
```
