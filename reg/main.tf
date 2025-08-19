terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.47.0"
    }
  }
}

provider "azuread" {
  # Optional: specify tenant_id if needed
  # tenant_id = "your-tenant-id-here"
}

# 🆕 Create App Registration with Microsoft Graph Permissions
resource "azuread_application" "example_app" {
  display_name     = "MyGraphApp"
  sign_in_audience = "AzureADMyOrg"

  web {
    redirect_uris = ["https://localhost/"]
  }

  required_resource_access {
    # Microsoft Graph API client ID (well-known)
    resource_app_id = "00000003-0000-0000-c000-000000000000"

    # Delegated Permission: User.Read
    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
      type = "Scope"
    }

    # Application Permission: Directory.ReadWrite.All
    resource_access {
      id   = "df021288-bdef-4463-88db-98f22de89214"
      type = "Role"
    }
  }
}

# 🧾 Output App Info
output "app_client_id" {
  value = azuread_application.example_app.client_id
}

output "app_object_id" {
  value = azuread_application.example_app.object_id
}
