# Azure AD Tenant
variable "tenant_id" {
  description = "Azure AD Tenant ID"
  type        = string
}

# App Registration
variable "app_name" {
  description = "App registration name"
  type        = string
}

# User
variable "user_email" {
  description = "User email (UPN)"
  type        = string
}

variable "user_display_name" {
  description = "User display name"
  type        = string
}

variable "user_password" {
  description = "User password"
  type        = string
  sensitive   = true
}

# Group
variable "group_name" {
  description = "Group name"
  type        = string
}
