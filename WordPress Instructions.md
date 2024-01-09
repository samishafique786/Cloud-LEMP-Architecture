# WordPress Installation and MySQL Configuration
## Step 1: Configuring MySQL on VM-2

It is assumed that you are still SSHed into your database server because first we need to configure MySQL to Listen for Remote Connections. We can do that by editing the mysqld.cnf file. Open it up using:
```bash
sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
```
It is a big file. You need to find the section where 
. . .
[mysqld]
. . .
in the parameter "bind-address" use the address of the Web Server in which you are going to install WordPress (VM-1). If they are in the same private subnet, you can put the private IP, if not, use use the public IP of VM-1. Also, to avoid sniffing attacks, you can secure the traffic by adding this line right below the bind-address parameter:
```bash
require_secure_transport = on
```
Now, you need to make sure that SSL connections work. To do that, MySQL has a command that will automatically set up keys and certificates.
```bash
sudo mysql_ssl_rsa_setup --uid=mysql
```
Now, restart the database to force it use these changes and make sure SSL works.
```bash
sudo systemctl restart MySQL
```
Time to confirm that the server is now listening on the external interface
```bash
sudo ss -plunt | grep mysqld
```
If it shows an output like this, you are good to go: 

Output
tcp     LISTEN   0        70             127.0.0.1:33060          0.0.0.0:*      users:(("mysqld",pid=4053,fd=22))                                              
tcp     LISTEN   0        151        db_server_ip:3306           0.0.0.0:*      users:(("mysqld",pid=4053,fd=24))

## Step 2: Configuring WordPress Database and Remote Credentials on the Database Server

We will now Create a database for wordpress, local user, and remote user.

1. Connect to MySQL as the root MySQL user
   ```bash
   sudo mysql
   ```
   You will be taken into the MySQL database prompt
   
3. Create a database for wordpress
   ```bash
   CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
   ```

To enhance security, create a local-only user and a remote user for your WordPress database.
4. Local and Remote User
   ```bash
  CREATE USER 'remote_user'@'web_server_ip' IDENTIFIED BY 'password';
  GRANT ALL PRIVILEGES ON wordpress.* TO 'remote_user'@'web_server_ip';
```
Now, flush the privileges and exit.
```bash
FLUSH PRIVILEGES;
exit
```
