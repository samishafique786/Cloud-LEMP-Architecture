# The Architecture, Explained

The project's infrastructure comprises two Ubuntu virtual machines: one acting as a web server (VM 1) with **Nginx** and **PHP**, and the other (VM-DB) as a MySQL database server. Deployed in a cloud environment of CSC (using Openstack), the web server handles HTTP/HTTPS requests, and the database server securely stores WordPress data in the MySQL database server. To enhance data security, the database server resides in a private subnet and is not directly accessible from the internet. The SSL certificates are implemented for encrypted connections. Terraform scripts facilitate seamless provisioning and destruction of the cloud environment. The overall setup ensures a scalable, secure, and efficient foundation for WordPress deployment in a cloud-based architecture.

# Deploying the Cloud Resources Using Terraform

After configuring and validating your cloud provider's account in the providers.tf file, it is time to write the resources and deploy them.

