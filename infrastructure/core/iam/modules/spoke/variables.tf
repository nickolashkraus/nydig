# -----------------------------------------------------------------------------
# REQUIRED VARIABLES
# -----------------------------------------------------------------------------

variable "hub_role_name" {
  type        = string
  description = "Name of the 'Hub' IAM role"
}

variable "spoke_role_name" {
  type        = string
  description = "Name of the 'Spoke' IAM role"
}

/* Add variables here... */
