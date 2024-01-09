# WordPress Installation and Configuration on VM-1 (the web server)
 Since WordPress using PHP and its different extensions, let us install the necessary ones before installing WordPress.

```bash
sudo apt install php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip
```
Now that the new extentions have been installed, let us restart PHP so that it make use of the new features
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

Again, check if the configuration files has syntax errors by typing
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

1. Generate secure values for WordPress:
```bash
curl -s https://api.wordpress.org/secret-key/1.1/salt/
```
you will recieve secure values. You need to paste them in the WordPress 

3. Open the WordPress Config File and Paste the Keys
```bash
sudo nano /var/www/your_domain/wp-config.php
```
Find the section that contains the example values for those settings:
/var/www/your_domain/wp-config.php

. . .
define('AUTH_KEY',         'put your unique phrase here');
define('SECURE_AUTH_KEY',  'put your unique phrase here');
define('LOGGED_IN_KEY',    'put your unique phrase here');
define('NONCE_KEY',        'put your unique phrase here');
define('AUTH_SALT',        'put your unique phrase here');
define('SECURE_AUTH_SALT', 'put your unique phrase here');
define('LOGGED_IN_SALT',   'put your unique phrase here');
define('NONCE_SALT',       'put your unique phrase here');
. . .
4. vv
