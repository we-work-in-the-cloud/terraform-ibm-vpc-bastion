variable "resource_group_id" {
  type        = string
  description = "ID of the resource group where to create the bastion instance and security groups"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC where to create the bastion"
}

variable "subnet_id" {
  type        = string
  description = "ID of the subnet where to create the bastion instance"
}

variable "name" {
  type        = string
  description = "Name of the bastion instance"
}

variable "image_name" {
  type        = string
  default     = "ibm-ubuntu-18-04-1-minimal-amd64-2"
  description = "Name of the image to use for the bastion instance"
}

variable "init_script" {
  type        = string
  default     = null
  description = "Script to run during the instance initialization. Defaults to an Ubuntu specific script when set to null"
}

variable "profile_name" {
  type        = string
  description = "Instance profile to use for the bastion instance"
  default     = "cx2-2x4"
}

variable "ssh_key_ids" {
  type        = list(string)
  description = "List of SSH key IDs to inject into the bastion instance"
}

variable "allow_ssh_from" {
  type        = string
  description = "An IP address, a CIDR block, or a single security group identifier to allow incoming SSH connection to the bastion"
  default     = "0.0.0.0/0"
}

variable "allow_ssh_to" {
  type        = list(string)
  description = "A list of IP addresses, CIDR blocks, and security group identifiers to allow outgoing SSH connection from the bastion"
  default = [
    "0.0.0.0/0"
  ]
}

variable "tags" {
  type        = list(string)
  description = "List of tags to add on all created resources"
  default     = []
}
