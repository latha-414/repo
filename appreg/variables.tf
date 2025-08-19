variable "tenant_id" {
  description = "Azure AD Tenant ID"
  type        = string
}

variable "app_name" {
  description = "Name of the Azure AD Application"
  type        = string
}

variable "sp_name" {
  description = "Name of the Service Principal (optional)"
  type        = string
  default     = ""
}

variable "user_name" {
  description = "User principal name (e.g., user@domain.com)"
  type        = string
}

variable "user_password" {
  description = "Initial password for new users"
  type        = string
  sensitive   = true
}

variable "group_name" {
  description = "Name of the Azure AD Group"
  type        = string
}
