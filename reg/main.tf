# main.tf
# Creates an App Registration in your Azure Active Directory using Terraform

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.49.0"
    }
  }
}

# Configure the Azure AD provider
provider "azuread" {
  tenant_id = "bc2e6364-d970-4392-87a4-2bfe5ec07c6f"  # Your tenant ID
}

# Local redirect URIs (defined inline, not as variables)
locals {
  redirect_uris = [
    "https://localhost:3000/signin-oidc",
    "https://example.com/auth/callback"
  ]
}

# Create an App Registration
resource "azuread_application" "my_app" {
  display_name = "My-Terraform-App"

  # Conditionally create web block only if redirect_uris is not empty
  dynamic "web" {
    for_each = length(local.redirect_uris) > 0 ? [1] : []
    content {
      redirect_uris = local.redirect_uris
    }
  }
}

# Output the App Registration details
output "app_client_id" {
  description = "The Client ID (Application ID) of the registered app"
  value       = azuread_application.my_app.client_id
}

output "app_object_id" {
  description = "The Object ID of the app in Azure AD"
  value       = azuread_application.my_app.object_id
}

output "app_display_name" {
  description = "Name of the app"
  value       = azuread_application.my_app.display_name
}
