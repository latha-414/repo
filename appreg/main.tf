terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.49.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

# Auth uses your Azure CLI login (no SP needed).
provider "azuread" {
  tenant_id = var.tenant_id
}

# Strong temporary password for the new user
resource "random_password" "user" {
  length  = 16
  special = true
}

# 1) Create a user
resource "azuread_user" "demo" {
  user_principal_name  = "${var.user_alias}@${var.default_domain}" # e.g., demo.user@contoso.onmicrosoft.com
  display_name         = var.user_display_name
  mail_nickname        = var.user_alias
  password             = random_password.user.result
  force_password_change = true
  account_enabled      = true
}

# 2) Create a security group (not mail-enabled)
resource "azuread_group" "demo" {
  display_name     = "demo-security-group"
  description      = "Security group created by Terraform"
  security_enabled = true
  mail_enabled     = false
  owners           = [azuread_user.demo.object_id]
}

# Add the user into the group
resource "azuread_group_member" "add_user" {
  group_object_id  = azuread_group.demo.object_id
  member_object_id = azuread_user.demo.object_id
}

# 3) Create an App Registration (Application object only)
resource "azuread_application" "app" {
  display_name = var.app_display_name

  # Make the created user an owner of the app (optional; remove if not desired)
  owners = [azuread_user.demo.object_id]

  # Optional web redirect URIs (leave empty to skip)
  dynamic "web" {
    for_each = length(var.redirect_uris) > 0 ? [1] : []
    content {
      redirect_uris = var.redirect_uris
    }
  }
}

output "user_upn" {
  value = azuread_user.demo.user_principal_name
}

# Keep this secret safe; rotate after first sign-in
output "user_temp_password" {
  value     = random_password.user.result
  sensitive = true
}

output "group_object_id" {
  value = azuread_group.demo.object_id
}

output "app_application_id" {
  # Client ID
  value = azuread_application.app.application_id
}

output "app_object_id" {
  value = azuread_application.app.object_id
}
