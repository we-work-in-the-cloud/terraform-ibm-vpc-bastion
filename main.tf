data "ibm_is_image" "image" {
  name = var.image_name
}

data "ibm_is_subnet" "subnet" {
  identifier = var.subnet_id
}

resource "ibm_is_security_group" "bastion" {
  name           = "${var.name}-group"
  vpc            = var.vpc_id
  resource_group = var.resource_group_id
}

resource "ibm_is_security_group_rule" "ssh" {
  group     = ibm_is_security_group.bastion.id
  direction = "inbound"
  remote    = var.allow_ssh_from
  tcp {
    port_min = 22
    port_max = 22
  }
}

resource "ibm_is_instance" "bastion" {
  name           = var.name
  vpc            = var.vpc_id
  zone           = data.ibm_is_subnet.subnet.zone
  profile        = var.profile_name
  image          = data.ibm_is_image.image.id
  keys           = var.ssh_key_ids
  resource_group = var.resource_group_id

  primary_network_interface {
    subnet          = data.ibm_is_subnet.subnet.id
    security_groups = [ibm_is_security_group.bastion.id]
  }

  boot_volume {
    name = "${var.name}-boot"
  }

  tags = var.tags
}

resource "ibm_is_floating_ip" "bastion" {
  name           = "${var.name}-ip"
  target         = ibm_is_instance.bastion.primary_network_interface.0.id
  resource_group = var.resource_group_id

  tags = var.tags
}
