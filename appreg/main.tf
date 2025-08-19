provider "azuread" {
  tenant_id = var.tenant_id
}

# Create App Registration
resource "azuread_application" "my_app" {
  display_name     = var.app_name
  sign_in_audience = "AzureADMyOrg"
}

# Optional: Create Service Principal
resource "azuread_service_principal" "my_app_sp" {
  client_id = azuread_application.my_app.application_id
}

# Create User
resource "azuread_user" "new_user" {
  user_principal_name  = var.user_name
  display_name         = "User New"
  password             = var.user_password
  force_password_change = true
}

# Create Group
resource "azuread_group" "new_group" {
  display_name     = var.group_name
  security_enabled = true
  mail_enabled     = false
}

# Add User to Group
resource "azuread_group_member" "add_user_to_group" {
  group_object_id  = azuread_group.new_group.id
  member_object_id = azuread_user.new_user.id
}
