provider "azuread" {
  # You can explicitly specify the tenant ID here if needed,
  # otherwise, it will use the tenant associated with your Azure CLI login.
  # tenant_id = "your_azure_ad_tenant_id"
}

resource "azuread_application" "my_app_registration" {
  display_name = "MyTerraformApp"
  sign_in_audience = "AzureADMyOrg" # Or other suitable audience like "AzureADMultipleOrgs"

  # Optional: Define redirect URIs for web applications
  web {
    redirect_uris = [
      "http://localhost:8080/auth/callback",
      "https://myapp.azurewebsites.net/auth/callback"
    ]
  }

  # Optional: Define API permissions if needed
  # api {
  #   oauth2_permission_scope {
  #     admin_consent_description  = "Allow the application to access user data."
  #     admin_consent_display_name = "Access user data"
  #     value                      = "user_impersonation"
  #     enabled                    = true
  #   }
  # }
}

# Optional: Create a service principal for the application
resource "azuread_service_principal" "my_app_service_principal" {
  application_id = azuread_application.my_app_registration.application_id
  # Optional: Define app role assignments if needed
  # app_role_assignment {
  #   app_role_id         = "some_app_role_id"
  #   principal_object_id = azuread_service_principal.my_app_service_principal.object_id
  #   resource_object_id  = azuread_application.my_app_registration.object_id
  # }
}

# Optional: Create a client secret for the application
resource "azuread_application_password" "my_app_secret" {
  application_object_id = azuread_application.my_app_registration.object_id
  display_name          = "MyTerraformAppSecret"
  # Optional: Set an end date for the secret
  # end_date              = "2026-12-31T23:59:59Z"
}

output "application_id" {
  value = azuread_application.my_app_registration.application_id
}

output "service_principal_object_id" {
  value = azuread_service_principal.my_app_service_principal.object_id
}

output "client_secret" {
  value     = azuread_application_password.my_app_secret.value
  sensitive = true # Mark as sensitive to prevent output in plain text
}
