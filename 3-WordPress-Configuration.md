# WordPress Installation and Configuration on VM-1 (the web server)
 Since WordPress using PHP and its different extensions, let us install the necessary ones before installing WordPress.

```bash
sudo apt install php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip
```
Now that the new extentions have been installed, let us restart PHP so that it make use of the new features
```bash
sudo systemctl restart php7.4-fpm
```

