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

resource "ibm_is_security_group_rule" "ssh_inbound" {
  group     = ibm_is_security_group.bastion.id
  direction = "inbound"
  remote    = var.allow_ssh_from
  tcp {
    port_min = 22
    port_max = 22
  }
}

resource "ibm_is_security_group_rule" "ssh_to_host_in_maintenance" {
  group     = ibm_is_security_group.bastion.id
  direction = "outbound"
  remote    = ibm_is_security_group.maintenance.id
  tcp {
    port_min = 22
    port_max = 22
  }
}

resource "ibm_is_security_group_rule" "additional_all_rules" {
  for_each = {
    for rule in var.security_group_rules : rule.name => rule if lookup(rule, "tcp", null) == null && lookup(rule, "udp", null) == null && lookup(rule, "icmp", null) == null
  }
  group      = ibm_is_security_group.bastion.id
  direction  = each.value.direction
  remote     = each.value.remote
  ip_version = lookup(each.value, "ip_version", null)
}

resource "ibm_is_security_group_rule" "additional_tcp_rules" {
  for_each   = {
    for rule in var.security_group_rules : rule.name => rule if lookup(rule, "tcp", null) != null
  }
  group      = ibm_is_security_group.bastion.id
  direction  = each.value.direction
  remote     = each.value.remote
  ip_version = lookup(each.value, "ip_version", null)

  tcp {
    port_min = each.value.tcp.port_min
    port_max = each.value.tcp.port_max
  }
}

resource "ibm_is_security_group_rule" "additional_udp_rules" {
  for_each   = {
    for rule in var.security_group_rules : rule.name => rule if lookup(rule, "udp", null) != null
  }
  group      = ibm_is_security_group.bastion.id
  direction  = each.value.direction
  remote     = each.value.remote
  ip_version = lookup(each.value, "ip_version", null)

  udp {
    port_min = each.value.udp.port_min
    port_max = each.value.udp.port_max
  }
}

resource "ibm_is_security_group_rule" "additional_icmp_rules" {
  for_each   = {
    for rule in var.security_group_rules : rule.name => rule if lookup(rule, "icmp", null) != null
  }
  group      = ibm_is_security_group.bastion.id
  direction  = each.value.direction
  remote     = each.value.remote
  ip_version = lookup(each.value, "ip_version", null)

  icmp {
    type = each.value.icmp.type
    code = lookup(each.value.icmp, "code", null) == null ? null : each.value.icmp.code
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

  user_data = var.init_script != null ? var.init_script : file("${path.module}/init-script-ubuntu.sh")

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

resource "ibm_is_security_group" "maintenance" {
  name           = "${var.name}-maintenance"
  vpc            = var.vpc_id
  resource_group = var.resource_group_id
}

resource "ibm_is_security_group_rule" "maintenance_ssh_inbound" {
  group     = ibm_is_security_group.maintenance.id
  direction = "inbound"
  remote    = ibm_is_security_group.bastion.id
  tcp {
    port_min = 22
    port_max = 22
  }
}
