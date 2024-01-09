# MySQL Configuration
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
## Step 3: Testing the Remote and Local Connections

### Testing Local DB User

To test the local connection,

```bash
mysql -u local_db_user -p
```
and now write the password you set. If the password is correct, you will be in the MySQL prompt of the local db user. You can exit the prompt by typing **exit**.

### Testing Remote DB User from Web Server

Drop the SSH connection from the VM-DB (the database server) and you will be SSHed back into the VM-1 (the webserver) from where you will test the remote database user and its connection to the database server. (remember, you have already created the remote user earlier)

1. Fisrt, Install MySQL Client Utilities
   ```bash
   sudo apt update
   sudo apt install mysql-client
   ```
2. Log into the Remote Database User
   ```bash
   mysql -u remote_user -h db_server_ip -p
   ```
You will now be required to enter the password you set earlier. If you've been logged into the remote database user, you will be taken to the MySQL prompt. Now, write **status** to see if the connection is using SSL.
![image](https://github.com/samishafique786/CloudWordPressDeployment/assets/108603607/66a49e9e-158e-4ff2-bd10-82ec90344b01)
As you can see, the connection is indeed using SSL. now, exit the prompt using **exit**.

