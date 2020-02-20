provider "aws" {
    region                  = var.aws_region
    shared_credentials_file = var.aws_credentials_file_location
    profile                 = var.profile
}

# Use existing Parameter
module "terraformy_existing" {
    source     = "../../../terraformy"
    app_name   = "${var.app_name}-old"
    aws_region = var.aws_region
    #Tags
    owners   = ["Test"]
    projects = ["Test-Project"]

    #VPC
    # If using existing VPC only set this:
    existing_vpcs = [var.existing_vpc_id]

    # Note by default security group will attempt to get created. To prevent this add a blank id to existing security group
    existing_security_group = [""]

    # At the moment we only handle 1 existing parameter at a time
    existing_parameter_store_name = [var.existing_parameter_store_name]
}

# Example create new Parameters
module "terraformy_new" {
    source     = "../../../terraformy"
    app_name   = "${var.app_name}-new"
    aws_region = var.aws_region
    #Tags
    owners   = ["Test"]
    projects = ["Test-Project"]

    #VPC
    existing_vpcs = [var.existing_vpc_id] # We are not using it here but the current module requires a vpc to be given

    # Note by default security group will attempt to get created. To prevent this add a blank id to existing security group
    existing_security_group = [""]

    # There are a couple ways of populating these values but the gist is we need 4 fields populated. 
    # These can be as separate lists and concatenated here or passed in as a map. This example creates a map from 4 different lists
    # This example requires the same number of fields for each list
    parameters = [
        for p in var.parameter_names:
        {"name"      = p,
        "description"= element(var.parameter_descriptions, index(var.parameter_names, p)),
        "type"       = element(var.parameter_types, index(var.parameter_names, p)),
        "value"      = element(var.parameter_values, index(var.parameter_names, p))}]

    # This example just takes the maps and uses them. You can look in variaables.tf to see how that slice map is set up
    # parameters = var.parameter_maps

    # This example take the maps and just sets their values. It gets the values from a hidden tfvars file
    # parameters = [
    #     for m in var.parameter_maps:
    #     m["value"] = element(var.hidden_values, index(var.parameter_maps, m))
    # ]
}
