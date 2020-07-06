provider "openstack" {
}

# Security groups
resource "openstack_compute_secgroup_v2" "ssh" {
  name        = "ssh"
  description = "ssh connection"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_compute_secgroup_v2" "http" {
  name        = "http"
  description = "http/https"

  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 443
    to_port     = 443
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_networking_floatingip_v2" "public_ip" {
  pool = var.ip_pool
}


data "openstack_images_image_v2" "egi-docker" {
  most_recent = true

  properties = {
    "ad:appid" = var.appdb_image_id 
  }
}

data "openstack_compute_flavor_v2" "master-flavor" {
  vcpus = var.master_cpus 
  ram   = var.master_ram 
}

data "openstack_compute_flavor_v2" "worker-flavor" {
  vcpus = var.worker_cpus 
  ram   = var.worker_ram 
}


resource "openstack_compute_instance_v2" "master" {
  name            = "k8s-master"
  image_id        = data.openstack_images_image_v2.egi-docker.id
  # 4 cores 4 GB RAM
  flavor_id       = data.openstack_compute_flavor_v2.master-flavor.id
  security_groups = ["default"]
  user_data       = file("cloud-init.yaml")
  tags = ["master"]
  network {
    uuid = var.net_id
  }
}

resource "openstack_compute_instance_v2" "nfs" {
  name            = "k8s-nfs"
  image_id        = data.openstack_images_image_v2.egi-docker.id
  flavor_id       = data.openstack_compute_flavor_v2.worker-flavor.id
  security_groups = ["default"]
  user_data       = file("cloud-init.yaml")
  tags = ["worker"]
  network {
    uuid = var.net_id
  }
}

resource "openstack_compute_instance_v2" "ingress" {
  name            = "k8s-w-ingress"
  image_id        = data.openstack_images_image_v2.egi-docker.id
  flavor_id       = data.openstack_compute_flavor_v2.worker-flavor.id
  security_groups = ["default", "ssh", "http"]
  user_data       = file("cloud-init.yaml")
  tags = ["worker"]
  network {
    uuid = var.net_id 
  }
}

resource "openstack_compute_instance_v2" "worker" {
  count           = var.extra_workers
  name            = "k8s-worker-${count.index}"
  image_id        = data.openstack_images_image_v2.egi-docker.id
  flavor_id       = data.openstack_compute_flavor_v2.worker-flavor.id
  security_groups = ["default"]
  user_data       = file("cloud-init.yaml")
  tags = ["worker"]
  network {
    uuid = var.net_id
  }
}
resource "openstack_compute_floatingip_associate_v2" "fip" {
  floating_ip = "${openstack_networking_floatingip_v2.public_ip.address}"
  instance_id = "${openstack_compute_instance_v2.ingress.id}"
}
