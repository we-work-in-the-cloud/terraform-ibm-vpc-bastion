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
| init\_script | Script to run during the instance initialization. Defaults to an Ubuntu specific script when set to empty | `string` | `""` | no |
| profile\_name | Instance profile to use for the bastion instance | `string` | `"cx2-2x4"` | no |
| ssh\_key\_ids | List of SSH key IDs to inject into the bastion instance | `list(string)` | n/a | yes |
| allow\_ssh\_from | An IP address, a CIDR block, or a single security group identifier to allow incoming SSH connection to the bastion | `string` | `"0.0.0.0/0"` | no |
| security\_group\_rules | List of security group rules to set on the bastion security group in addition to the SSH rules | `list` | <pre>[<br>  {<br>    "direction": "outbound",<br>    "name": "http_outbound",<br>    "remote": "0.0.0.0/0",<br>    "tcp": {<br>      "port_max": 80,<br>      "port_min": 80<br>    }<br>  },<br>  {<br>    "direction": "outbound",<br>    "name": "https_outbound",<br>    "remote": "0.0.0.0/0",<br>    "tcp": {<br>      "port_max": 443,<br>      "port_min": 443<br>    }<br>  },<br>  {<br>    "direction": "outbound",<br>    "name": "dns_outbound",<br>    "remote": "0.0.0.0/0",<br>    "udp": {<br>      "port_max": 53,<br>      "port_min": 53<br>    }<br>  },<br>  {<br>    "direction": "outbound",<br>    "icmp": {<br>      "type": 8<br>    },<br>    "name": "icmp_outbound",<br>    "remote": "0.0.0.0/0"<br>  }<br>]</pre> | no |
| tags | List of tags to add on all created resources | `list(string)` | `[]` | no |
| disable\_floating\_ip | Flag indicating that the bastion instance should be provisioned without attaching a floating ip. This configuration is useful for servers that are accessible behind a vpn server. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| bastion\_id | ID of the bastion virtual server instance |
| bastion\_private\_ip | Private IP address of the bastion virtual server instance |
| bastion\_public\_ip | Public IP address of the bastion virtual server instance |
| bastion\_security\_group\_id | ID of the security group assigned to the bastion interface |
| bastion\_maintenance\_group\_id | ID of the security group used to allow connection from the bastion to your instances |

## License

Apache 2 Licensed. See [LICENSE](LICENSE) for full details.
