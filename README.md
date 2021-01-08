# Bastion for VPC Terraform Module

This module deploys a bastion instance into an existing VPC. A bastion is an instance that is provisioned with a public IP address and can be accessed via SSH. Once set up, the bastion host acts as a jump server allowing secure connection to instances provisioned without a public IP address.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| ibm | >= 1.18.0 |

## Providers

| Name | Version |
|------|---------|
| ibm | >= 1.18.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| resource\_group\_id | ID of the resource group where to create the bastion instance and security groups | `string` | n/a | yes |
| vpc\_id | ID of the VPC where to create the bastion | `string` | n/a | yes |
| subnet\_id | ID of the subnet where to create the bastion instance | `string` | n/a | yes |
| name | Name of the bastion instance | `string` | n/a | yes |
| image\_name | Name of the image to use for the bastion instance | `string` | `"ibm-ubuntu-18-04-1-minimal-amd64-2"` | no |
| init\_script | Script to run during the instance initialization. Defaults to an Ubuntu specific script when set to null | `string` | `null` | no |
| profile\_name | Instance profile to use for the bastion instance | `string` | `"cx2-2x4"` | no |
| ssh\_key\_ids | List of SSH key IDs to inject into the bastion instance | `list(string)` | n/a | yes |
| allow\_ssh\_from | An IP address, a CIDR block, or a single security group identifier to allow incoming SSH connection to the bastion | `string` | `"0.0.0.0/0"` | no |
| allow\_ssh\_to | A list of IP addresses, CIDR blocks, and security group identifiers to allow outgoing SSH connection from the bastion | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| tags | List of tags to add on all created resources | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| bastion\_id | ID of the bastion virtual server instance |
| bastion\_private\_ip | Private IP address of the bastion virtual server instance |
| bastion\_public\_ip | Public IP address of the bastion virtual server instance |
| bastion\_security\_group\_id | ID of the security group assigned to the bastion interface |
| bastion\_maintenance\_group\_id | ID of the security group used to allow connection from the bastion to your instances |

## License

Apache 2 Licensed. See LICENSE for full details.