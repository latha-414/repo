terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.47.0"
    }
  }
}

provider "azuread" {
  # Assumes you're authenticated via Azure CLI or environment variables
}

# 🔍 Get Microsoft Graph Service Principal
data "azuread_service_principal" "ms_graph" {
  display_name = "Microsoft Graph"
}

# 🆕 Create App Registration
resource "azuread_application" "example_app" {
  display_name = "MyGraphApp"
  sign_in_audience = "AzureADMyOrg"
  web {
    redirect_uris = ["https://localhost"]
  }
}

# 🔐 Assign Microsoft Graph API Permissions

## Delegated Permission: User.Read
resource "azuread_application_api_permission" "user_read" {
  application_object_id = azuread_application.example_app.object_id
  api_client_id          = data.azuread_service_principal.ms_graph.client_id
  permission_id          = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
  type                   = "Scope"
}

## Application Permission: Directory.ReadWrite.All
resource "azuread_application_api_permission" "directory_rw" {
  application_object_id = azuread_application.example_app.object_id
  api_client_id          = data.azuread_service_principal.ms_graph.client_id
  permission_id          = "df021288-bdef-4463-88db-98f22de89214" # Directory.ReadWrite.All
  type                   = "Role"
}

# 🧾 Optional: Output App Info
output "app_id" {
  value = azuread_application.example_app.application_id
}

output "object_id" {
  value = azuread_application.example_app.object_id
}
