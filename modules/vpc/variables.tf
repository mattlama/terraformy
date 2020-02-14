#Tags
variable "owners" {
    description = "This will apply the first owner provided to all the Owner fields in tags. It will default to Terraform as owner in tags.tf if none are provided"
    default = []
}

variable "projects" {
    description = "This will apply the first project provided to all the Project fields in tags. It will default to Terraform-AppName as project in tags.tf if none are provided"
    default = []
}

#VPC
variable "app_name" {
    description = "Required if creating new VPC. This is the app name which will be used in the creation of all components in this outline"
    default = ""
}

variable "existing_vpcs" {
    description = "If the user wants to put their new components into an existing VPC they may do so. This is an array of VPC ids but will only use the first value"
    default     = []
}

variable "cidr_block" {
    description = "Required if creating new VPC"
    default = "0.0.0.0/16"
}

variable "availability_zones" {
    description = "Required if creating new VPC. These are the availability zones associated with the VPC"
    default = []
}

variable "private_subnets" {
    description = "Required if creating new VPC. We need one set of subnets for each availability_zone and they must fall within the CIDR block"
    default = []
}

variable "public_subnets" {
    description = "Required if creating new VPC. We need one set of subnets for each availability_zone and they must fall within the CIDR block"
    default = []
}

variable "enable_dns_hostnames" {
    description = ""
    type = bool
    default = true
}

variable "enable_nat_gateway" {
    description = ""
    type = bool
    default = true
}

variable "enable_vpn_gateway" {
    description = ""
    type = bool
    default = false
}

variable "single_nat_gateway" {
    description = ""
    type = bool
    default = false
}

variable "reuse_nat_ips" {
    description = ""
    type = bool
    default = true # <= Skip creation of EIPs for the NAT Gateways
}