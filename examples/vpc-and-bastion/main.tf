terraform {
  required_providers {
    ibm = {
      source  = "ibm-cloud/ibm"
      version = ">= 1.18.0"
    }
  }
  required_version = ">= 0.13"
}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
}

# where to create resource, defaults to the default resource group
data "ibm_resource_group" "resource_group" {
  name       = var.resource_group
  is_default = var.resource_group == null ? true : null
}

# a vpc
resource "ibm_is_vpc" "vpc" {
  name                      = var.name
  resource_group            = data.ibm_resource_group.resource_group.id
  address_prefix_management = "manual"
}

# its address prefix
resource "ibm_is_vpc_address_prefix" "subnet_prefix" {
  name = "${var.name}-zone-1"
  zone = "${var.region}-1"
  vpc  = ibm_is_vpc.vpc.id
  cidr = "10.10.10.0/24"
}

# a subnet
resource "ibm_is_subnet" "subnet" {
  name            = "${var.name}-subnet"
  vpc             = ibm_is_vpc.vpc.id
  zone            = "${var.region}-1"
  resource_group  = data.ibm_resource_group.resource_group.id
  ipv4_cidr_block = ibm_is_vpc_address_prefix.subnet_prefix.cidr
}

# ssh key to inject into the bastion and the instance
data "ibm_is_ssh_key" "sshkey" {
  name = var.ssh_key_name
}

# one bastion
module "bastion" {
  source  = "we-work-in-the-cloud/vpc-bastion/ibm"

  vpc_id            = ibm_is_vpc.vpc.id
  resource_group_id = data.ibm_resource_group.resource_group.id
  name              = "${var.name}-bastion"
  ssh_key_ids       = [data.ibm_is_ssh_key.sshkey.id]
  subnet_id         = ibm_is_subnet.subnet.id
}

# one private instance
data "ibm_is_image" "image" {
  name = var.image_name
}

resource "ibm_is_instance" "instance" {
  name           = "${var.name}-instance"
  vpc            = ibm_is_vpc.vpc.id
  zone           = ibm_is_subnet.subnet.zone
  profile        = var.profile_name
  image          = data.ibm_is_image.image.id
  keys           = [data.ibm_is_ssh_key.sshkey.id]
  resource_group = data.ibm_resource_group.resource_group.id

  primary_network_interface {
    subnet = ibm_is_subnet.subnet.id
  }

  boot_volume {
    name = "${var.name}-instance-boot"
  }
}

# add the instance to the bastion maintenance group so that
# it can be accessed by the bastion
resource "ibm_is_security_group_network_interface_attachment" "under_maintenance" {
  network_interface = ibm_is_instance.instance.primary_network_interface.0.id
  security_group    = module.bastion.bastion_maintenance_group_id
}

output "ssh_command" {
  value       = "ssh -o StrictHostKeyChecking=no -o ProxyCommand='ssh -o StrictHostKeyChecking=no -W %h:%p root@${module.bastion.bastion_public_ip}' root@${ibm_is_instance.instance.primary_network_interface.0.primary_ipv4_address}"
  description = "Command to use to jump from the bastion to the instance assuming you are using your own default SSH key on bastion and instances"
}
