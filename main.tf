# static web app
resource "azurerm_static_web_app" "stapp" {
  resource_group_name = coalesce(
    lookup(var.instance, "resource_group_name", null),
    var.resource_group_name
  )

  location = coalesce(
    lookup(var.instance, "location", null),
    var.location
  )

  name                               = var.instance.name
  sku_tier                           = var.instance.sku_tier
  sku_size                           = var.instance.sku_size
  configuration_file_changes_enabled = var.instance.configuration_file_changes_enabled
  preview_environments_enabled       = var.instance.preview_environments_enabled
  public_network_access_enabled      = var.instance.public_network_access_enabled

  app_settings = var.instance.app_settings

  repository_url    = var.instance.repository_url
  repository_token  = var.instance.repository_token
  repository_branch = var.instance.repository_branch

  dynamic "identity" {
    for_each = var.instance.identity != null ? [var.instance.identity] : []

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "basic_auth" {
    for_each = var.instance.basic_auth != null ? [var.instance.basic_auth] : []

    content {
      environments = basic_auth.value.environments
      password     = basic_auth.value.password
    }
  }

  tags = try(
    var.instance.tags, var.tags, null
  )
}

# custom domains
resource "azurerm_static_web_app_custom_domain" "domains" {
  for_each = try(var.instance.custom_domains, {})

  static_web_app_id = azurerm_static_web_app.stapp.id
  validation_type   = each.value.validation_type

  domain_name = coalesce(
    lookup(each.value, "domain_name", null),
    each.key
  )
}

# function app registration
resource "azurerm_static_web_app_function_app_registration" "function_app" {
  for_each = var.instance.function_app_registration != null ? { "backend" = var.instance.function_app_registration } : {}

  static_web_app_id = azurerm_static_web_app.stapp.id
  function_app_id   = each.value.function_app_id
}
