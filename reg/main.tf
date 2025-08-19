terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.47.0" # or latest stable you have
    }
  }
}

provider "azuread" {
  tenant_id = "bc2e6364-d970-4392-87a4-2bfe5ec07c6f" # your tenant
}

# App Registration
resource "azuread_application" "example" {
  display_name = "Test-App-From-Terraform"
  
  # Optional: single-tenant (same as default in portal)
  sign_in_audience = "AzureADMyOrg"
}
