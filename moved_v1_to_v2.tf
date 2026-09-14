moved {
  from = azurerm_static_web_app.stapp
  to   = azurerm_static_web_app.this
}

moved {
  from = azurerm_static_web_app_custom_domain.domains
  to   = azurerm_static_web_app_custom_domain.this
}

moved {
  from = azurerm_static_web_app_function_app_registration.function_app["backend"]
  to   = azurerm_static_web_app_function_app_registration.this["this"]
}
