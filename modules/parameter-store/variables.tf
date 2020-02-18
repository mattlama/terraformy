# TODO Refactor this so we do not need 4 lists running side by side
variable "names" {
  description = "This is the key the parameter will be saved to. They should be in the same order as their values"
  default     = []
}

variable "descriptions" {
  description = "These are the descriptions for the parameters we are creating. They should be in the same order as their values"
  default     = []
}

variable "types" {
  description = "These are the types of parameters which will be stored as parameters in the parameter store. They should be in the same order as their values"
  default     = []
}

variable "values" {
  description = "These are the values which will be stored to the parameters. They should be in the same order as their values"
  default     = []
}

variable "existing_parameter" {
  description = "Gets the value of an existing parameter"
  default     = []
}