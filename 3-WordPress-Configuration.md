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
