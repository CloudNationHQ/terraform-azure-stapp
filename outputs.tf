output "instance" {
  description = "contains all static web app configuration"
  value       = azurerm_static_web_app.stapp
}

output "custom_domains" {
  description = "contains custom domain configurations"
  value       = azurerm_static_web_app_custom_domain.domains
}

output "function_app_registration" {
  description = "contains function app registration configuration"
  value       = try(azurerm_static_web_app_function_app_registration.function_app["backend"], null)
}
