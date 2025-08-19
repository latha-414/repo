terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.47.0"
    }
  }
}

provider "azuread" {}

# 🔍 Get Microsoft Graph Service Principal
data "azuread_service_principal" "ms_graph" {
  display_name = "Microsoft Graph"
}

# 🆕 Create App Registration with Microsoft Graph Permissions
resource "azuread_application" "example_app" {
  display_name     = "MyGraphApp"
  sign_in_audience = "AzureADMyOrg"

  web {
    redirect_uris = ["https://localhost/"]
  }

  required_resource_access {
    resource_app_id = data.azuread_service_principal.ms_graph.application_id

    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read (Delegated)
      type = "Scope"
    }

    resource_access {
      id   = "df021288-bdef-4463-88db-98f22de89214" # Directory.ReadWrite.All (Application)
      type = "Role"
    }
  }
}

# 🧾 Output App Info
output "app_id" {
  value = azuread_application.example_app.application_id
}

output "object_id" {
  value = azuread_application.example_app.object_id
}
