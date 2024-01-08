data "openstack_networking_network_v2" "private_network" {
  name = "project_2008942"
}

data "openstack_networking_subnet_v2" "private_subnet" {
  name      = "project_2008942"
  network_id = data.openstack_networking_network_v2.private_network.id
}

data "openstack_networking_router_v2" "router" {
  name      = "project_2008942-router"
  router_id = "bf09ee68-8440-4b61-ab0d-896793bb50ae"
}

# Resources
resource "openstack_networking_secgroup_v2" "public_sg" {
  name        = "public_sg"
  description = "Allow SSH, HTTP, and HTTPS"
}

resource "openstack_networking_secgroup_rule_v2" "public_sg_rule_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.public_sg.id
}

resource "openstack_networking_secgroup_rule_v2" "public_sg_rule_http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.public_sg.id
}

resource "openstack_networking_secgroup_rule_v2" "public_sg_rule_https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.public_sg.id
}

resource "openstack_networking_secgroup_v2" "private_sg" {
  name        = "private_sg"
  description = "Allow internal traffic"
}

resource "openstack_networking_secgroup_rule_v2" "private_sg_rule_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "192.168.1.0/24"
  security_group_id = openstack_networking_secgroup_v2.private_sg.id
}

resource "openstack_networking_secgroup_rule_v2" "private_sg_rule_mysql" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 3306
  port_range_max    = 3306
  remote_ip_prefix  = "192.168.1.0/24"
  security_group_id = openstack_networking_secgroup_v2.private_sg.id
}

resource "openstack_compute_instance_v2" "vm1" {
  count           = 1
  name            = "VM-1"
  image_name      = "Ubuntu-20.04"
  flavor_name     = "standard.small"
  key_pair        = "cloud"
  security_groups = [
    openstack_networking_secgroup_v2.public_sg.name,
    openstack_networking_secgroup_v2.private_sg.name,
  ]
  depends_on      = [data.openstack_networking_subnet_v2.private_subnet]

  network {
    uuid = data.openstack_networking_network_v2.private_network.id
  }
}

resource "openstack_compute_instance_v2" "vm2" {
  count           = 1
  name            = "VM-DB"
  image_name      = "Ubuntu-20.04"
  flavor_name     = "standard.small"
  key_pair        = "cloud"
  security_groups = [openstack_networking_secgroup_v2.private_sg.name]
  depends_on      = [data.openstack_networking_subnet_v2.private_subnet]

  network {
    uuid = data.openstack_networking_network_v2.private_network.id
  }
}

resource "openstack_networking_floatingip_v2" "vm1_fip" {
  pool = "public"
}

resource "openstack_compute_floatingip_associate_v2" "fip_assoc" {
  floating_ip = openstack_networking_floatingip_v2.vm1_fip.address
  instance_id = openstack_compute_instance_v2.vm1[0].id
}