variable "tenant_id" {
  type        = string
  description = "Entra ID tenant ID (GUID)."
}

variable "default_domain" {
  type        = string
  description = "Verified tenant domain, e.g., contoso.onmicrosoft.com"
}

variable "user_alias" {
  type        = string
  description = "Left part of UPN, e.g., demo.user -> demo.user@domain"
  default     = "demo.user"
}

variable "user_display_name" {
  type        = string
  default     = "Demo User"
}

variable "app_display_name" {
  type        = string
  default     = "demo-app"
}

variable "redirect_uris" {
  type        = list(string)
  description = "Optional web redirect URIs for the app"
  default     = []
}
