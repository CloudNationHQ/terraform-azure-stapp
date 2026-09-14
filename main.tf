# static web app
resource "azurerm_static_web_app" "this" {
  name                = var.app.name
  resource_group_name = coalesce(var.app.resource_group_name, var.resource_group_name)
  location            = coalesce(var.app.location, var.location)
  tags                = coalesce(var.app.tags, var.tags)

  sku_tier                           = var.app.sku_tier
  sku_size                           = var.app.sku_size
  configuration_file_changes_enabled = var.app.configuration_file_changes_enabled
  preview_environments_enabled       = var.app.preview_environments_enabled
  public_network_access_enabled      = var.app.public_network_access_enabled

  app_settings = var.app.app_settings

  repository_url    = var.app.repository_url
  repository_token  = var.app.repository_token
  repository_branch = var.app.repository_branch

  dynamic "identity" {
    for_each = var.app.identity != null ? { "this" = var.app.identity } : {}

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "basic_auth" {
    for_each = var.app.basic_auth != null ? { "this" = var.app.basic_auth } : {}

    content {
      environments = basic_auth.value.environments
      password     = basic_auth.value.password
    }
  }
}

# custom domains
resource "azurerm_static_web_app_custom_domain" "this" {
  for_each = var.app.custom_domains

  static_web_app_id = azurerm_static_web_app.this.id
  validation_type   = each.value.validation_type

  domain_name = coalesce(each.value.domain_name, each.key)
}

# function app registration
resource "azurerm_static_web_app_function_app_registration" "this" {
  # function_app_id is often derived from a sensitive module output, which
  # terraform rejects in for_each; the splat keeps the map free of sensitive
  # marks while still yielding zero or one instance
  for_each = { for v in var.app.function_app_registration[*] : "this" => {} }

  static_web_app_id = azurerm_static_web_app.this.id
  function_app_id   = var.app.function_app_registration.function_app_id
}
