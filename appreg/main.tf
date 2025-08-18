# Configure Azure AD Provider
terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>2.0"
    }
  }
}

provider "azuread" {
  tenant_id = var.tenant_id
}

# Create App Registration
resource "azuread_application" "app" {
  display_name = var.app_name
}

# Create Service Principal for the App
resource "azuread_service_principal" "app_sp" {
  application_id = azuread_application.app.application_id
}

# Create User
resource "azuread_user" "user" {
  user_principal_name = var.user_email
  display_name        = var.user_display_name
  password            = var.user_password
}

# Create Group
resource "azuread_group" "group" {
  display_name     = var.group_name
  security_enabled = true
}

# Add User to Group
resource "azuread_group_member" "member" {
  group_object_id  = azuread_group.group.object_id
  member_object_id = azuread_user.user.object_id
}
