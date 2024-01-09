# WordPress Installation and Configuration on VM-1 (the web server)
 Since WordPress uses PHP and its different extensions, let us install the necessary ones before installing WordPress.

```bash
sudo apt install php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip
```
Now that the new extensions have been installed, let us restart PHP so that it makes use of the new features
```bash
sudo systemctl restart php7.4-fpm
```

## Nginx Configuration Adjustments
Follow these steps to modify your Nginx server block for optimal WordPress performance.
1. pen your site's server block file:
   ```bash
   sudo nano /etc/nginx/sites-available/your_domain
   ```
Replace your_domain with your actual domain or public IP of the web server.
2. Add the following location blocks for static files, excluding them from logging
```bash
location = /favicon.ico { log_not_found off; access_log off; }
location = /robots.txt { log_not_found off; access_log off; allow all; }
location ~* \.(css|gif|ico|jpeg|jpg|js|png)$ {
    expires max;
    log_not_found off;
}
```
The <your_domain> file now looks like [this](https://github.com/samishafique786/CloudWordPressDeployment/blob/main/VM-1%20Files/128.214.253.37).

**Note: The server block now listens on port 443 with SSL, includes the SSL snippets, and redirects HTTP traffic to HTTPS (80 to 443 port)**

Again, check if the configuration files have syntax errors by typing
```bash
sudo nginx -t
```
and then finally, reload NGINX.
```bash
sudo systemctl reload nginx
```

## Install WordPress on the Web Server (VM-1)
1. Change to a writable directory, for example, /tmp: and download WordPress
```bash
cd /tmp
curl -LO https://wordpress.org/latest.tar.gz
```
2. Extract the compressed file
   ```bash
   tar xzvf latest.tar.gz
   ```
3. Copy the sample configuration file that's been downloaded.
   ```bash
   cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php
   ```
4. Copy the WordPress file to your document root
   ```bash
   sudo cp -a /tmp/wordpress/. /var/www/your_domain
   ```
5. Set ownership for Nginx to read and write:
```bash
sudo chown -R www-data:www-data /var/www/your_domain
```

## Setting up the WordPress Configuration File

### 1. Generate secure values for WordPress:
```bash
curl -s https://api.wordpress.org/secret-key/1.1/salt/
```
you will receive secure values. You need to paste them into the WordPress config file

### 2. Open the WordPress Config File and Paste the Keys
```bash
sudo nano /var/www/your_domain/wp-config.php
```
Find the section that contains the example values for those settings and paste the appropriate keys:
/var/www/your_domain/wp-config.php
![image](https://github.com/samishafique786/CloudWordPressDeployment/assets/108603607/984d73aa-779d-47c9-b713-3f8bc0b2bf9e)

### 3. In the same config file, at the top of the file, modify the database connection settings:
 ![image](https://github.com/samishafique786/CloudWordPressDeployment/assets/108603607/56204419-926b-453e-8985-eec4e830f6cb)
### 4. After the **define('DB_HOST', 'db_server_ip');** line, add the following line to make sure WordPress uses SSL secure remote connection to MySQL database:
   ```bash
   define('MYSQL_CLIENT_FLAGS', MYSQLI_CLIENT_SSL);
   ```
save and close the file now.


# Self-Signed SSL Certificate Setup for Nginx 
## Creating the SSL Certificate

### Generate a self-signed key and certificate pair using OpenSSL
The following command will create a key file and a certificate in the directory /etc/ssl 

```bash
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
```
After you run this command, you will be asked a series of questions. In the **Common Name**, write the domain name or the IP of you Web Server.

## Configure NGINX to use SSL Certificate
### 1. Create a configuration snippet for NGINX to use the SSL certificate
   ```bash
   sudo nano /etc/nginx/snippets/self-signed.conf
   ```
   Add the following lines to the file and save the file
   ```bash
   ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;
   ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;
   ```
### 2. Create another snippet for more secure SSL using recommendations from Cipherlist.eu
   ```bash
   sudo nano /etc/nginx/snippets/ssl-params.conf
   ```
   Paste the following
   ```bash
   ssl_protocols TLSv1.3;
   ssl_prefer_server_ciphers on;
   ssl_dhparam /etc/nginx/dhparam.pem; 
   ssl_ciphers EECDH+AESGCM:EDH+AESGCM;
   ssl_ecdh_curve secp384r1;
   ssl_session_timeout  10m;
   ssl_session_cache shared:SSL:10m;
   ssl_session_tickets off;
   ssl_stapling on;
   ssl_stapling_verify on;
   resolver 8.8.8.8 8.8.4.4 valid=300s;
   resolver_timeout 5s;
   # Disable strict transport security for now. You can uncomment the following
   # line if you understand the implications.
   #add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload";
   add_header X-Frame-Options DENY;
   add_header X-Content-Type-Options nosniff;
   add_header X-XSS-Protection "1; mode=block";
   ```
### 3. Adjust the Nginx Configuration to Use SSL
You should back your current configuration file before proceeding:
```bash
sudo cp /etc/nginx/sites-available/your_domain /etc/nginx/sites-available/your_domain.bak
# replace your_domain with the domain or Web Server IP
```
Open the configuration file
```bash
sudo nano /etc/nginx/sites-available/your_domain
```
If you've copied and pasted the contents of the file from the [file provided](https://github.com/samishafique786/CloudWordPressDeployment/blob/main/VM-1%20Files/your_domain), NGINX is already configured to be using SSL. if not, paste the contents of the file provided to your configuration file. 
