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
# Uses your current az login session (run `az login` first)
provider "azuread" {
  tenant_id = "bc2e6364-d970-4392-87a4-2bfe5ec07c6f"  # 👈 Replace with your actual tenant ID (e.g., aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee)
}

# Create an App Registration
resource "azuread_application" "my_app" {
  display_name = "My-Terraform-App"  # 👈 Change this name if you want

  # Optional: Add redirect URIs (e.g., for web app login)
  # Remove or set empty list if not needed
  dynamic "web" {
    for_each = length(var.redirect_uris) > 0 ? [1] : []
    content {
      redirect_uris = [
        "https://localhost:3000/signin-oidc",
        "https://example.com/auth/callback"
      ] # 👈 Modify or remove as needed
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
