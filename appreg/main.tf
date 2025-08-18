terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
  }
}

# Auth will use your 'az login' session; we only pass tenant_id
provider "azuread" {
  tenant_id = var.tenant_id
}

# --- App Registration ---
resource "azuread_application" "app" {
  display_name = var.app_name
}

# --- User ---
resource "azuread_user" "user" {
  user_principal_name   = var.user_email          # e.g. test.user@yourtenant.onmicrosoft.com
  display_name          = var.user_display_name   # e.g. "Test User"
  mail_nickname         = var.user_mail_nickname  # e.g. "testuser"
  password              = var.user_password       # meet tenant password policy
  force_password_change = false
}

# --- Group ---
resource "azuread_group" "group" {
  display_name     = var.group_name               # e.g. "MyAppUsers"
  security_enabled = true
  mail_enabled     = false
}

# --- Add user to group ---
resource "azuread_group_member" "member" {
  group_object_id  = azuread_group.group.object_id
  member_object_id = azuread_user.user.object_id
}
