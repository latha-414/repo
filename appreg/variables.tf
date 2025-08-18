variable "tenant_id" {
  description = "Azure AD tenant ID (GUID)"
  type        = string
}

variable "app_name" {
  description = "Display name for the App Registration"
  type        = string
}

variable "user_email" {
  description = "UPN for the new user (must be in this tenant)"
  type        = string
}

variable "user_display_name" {
  description = "Display name for the new user"
  type        = string
}

variable "user_mail_nickname" {
  description = "Mail nickname (alias) for the new user"
  type        = string
}

variable "user_password" {
  description = "Initial password for the new user"
  type        = string
  sensitive   = true
}

variable "group_name" {
  description = "Display name for the new group"
  type        = string
}
