output "bastion_id" {
  value       = ibm_is_instance.bastion.id
  description = "ID of the bastion virtual server instance"
}

output "bastion_private_ip" {
  value       = ibm_is_instance.bastion.primary_network_interface.0.primary_ipv4_address
  description = "Private IP address of the bastion virtual server instance"
}

output "bastion_public_ip" {
  value       = ibm_is_floating_ip.bastion.address
  description = "Public IP address of the bastion virtual server instance"
}

output "bastion_security_group_id" {
  value       = ibm_is_security_group.bastion.id
  description = "ID of the security group assigned to the bastion interface"
}