# Example - VPC and Bastion

This example illustrates how to use the bastion module.

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
| ibmcloud\_api\_key | n/a | `string` | n/a | yes |
| image\_name | Name of the image to use for the private instance | `string` | `"ibm-ubuntu-18-04-1-minimal-amd64-2"` | no |
| name | Prefix to use to create the example resources | `string` | `"vpc-and-bastion"` | no |
| profile\_name | Instance profile to use for the private instance | `string` | `"cx2-2x4"` | no |
| region | Region where to deploy the example | `string` | `"us-south"` | no |
| resource\_group | Resource group where to create resources | `string` | `null` | no |
| ssh\_key\_name | Name of an existing VPC SSH key to inject into the bastion and instance to allow remote connection | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| ssh_command | Command to use to jump from the bastion to the instance assuming you are using your own default SSH key on bastion and instances. |
