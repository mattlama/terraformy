module "parameters" {
  source             = "../parameter-store"
  names              = var.parameter_store_names
  descriptions       = var.parameter_store_descriptions
  types              = var.parameter_store_types
  values             = var.parameter_store_values
  existing_parameter = var.existing_parameter_store_name
}