#Jumbo
variable "app_name" {
    description = "Required. This is the app name which will be used in the creation of all components in this outline. NOTE AWS has limitations on certain components such as 32 characters in length or must be all lowercase for ecr repositories"
}

variable "existing_vpcs" {
    description = "If the user wants to put their new components into an existing VPC they may do so. This is an array of VPC ids but will only use the first value"
    default     = []
}

#Tags
variable "owners" {
    description = "This will apply the first owner provided to all the Owner fields in tags. It will default to Terraform as owner in tags.tf if none are provided"
    default     = []
}

variable "projects" {
    description = "This will apply the first project provided to all the Project fields in tags. It will default to Terraform-AppName as project in tags.tf if none are provided"
    default     = []
}

#VPC
variable "cidr_block" {
    description = "Required if creating new VPC"
    default     = "0.0.0.0/16"
}

variable "availability_zones" {
    description = "Required if creating new VPC. These are the availability zones associated with the VPC"
    default     = []
}

variable "private_subnets" {
    description = "Required if creating new VPC. We need one set of subnets for each availability_zone and they must fall within the CIDR block"
    default     = []
}

variable "public_subnets" {
    description = "Required if creating new VPC. We need one set of subnets for each availability_zone and they must fall within the CIDR block"
    default     = []
}

variable "enable_dns_hostnames" {
    description = ""
    type        = bool
    default     = true
}

variable "enable_nat_gateway" {
    description = ""
    type        = bool
    default     = true
}

variable "enable_vpn_gateway" {
    description = ""
    type        = bool
    default     = false
}

variable "single_nat_gateway" {
    description = ""
    type        = bool
    default     = false
}

variable "reuse_nat_ips" {
    description = ""
    type        = bool
    default     = true # <= Skip creation of EIPs for the NAT Gateways
}

#Security
#TODO Expand to directly take a security group ID. This currently assumes you know the VPC and you know a security group exists but do not have the id at hand
variable "existing_security_group" {
    description = "Leave blank to create a new security group. Otherwise it will use the VPC id to find an associated security group"
    default = []
}

variable "ingress_rules" {
    description = "Required when creating new security groups"
    default = ["https-443-tcp", "http-80-tcp", "http-8080-tcp"]
}

variable "ingress_cidr_blocks" {
    description = "Required when creating new security groups"
    default = ["0.0.0.0/0"]
}

variable "egress_rules" {
    description = "Required when creating new security groups"
    default = ["https-443-tcp", "http-80-tcp", "http-8080-tcp", "mssql-tcp"]
}

variable "egress_cidr_blocks" {
    description = "Required when creating new security groups"
    default = ["0.0.0.0/0"]
}
