module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.25"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 3.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "westeurope"
    }
  }
}

module "analytics" {
  source  = "cloudnationhq/law/azure"
  version = "~> 4.0"

  workspace = {
    name                = module.naming.log_analytics_workspace.name
    resource_group_name = module.rg.groups.demo.name
    location            = module.rg.groups.demo.location
  }
}

module "appi" {
  source  = "cloudnationhq/appi/azure"
  version = "~> 4.0"

  insights = {
    name                = module.naming.application_insights.name
    resource_group_name = module.rg.groups.demo.name
    location            = module.rg.groups.demo.location
    application_type    = "web"
    workspace_id        = module.analytics.workspace.id
  }
}

module "stapp" {
  source  = "cloudnationhq/stapp/azure"
  version = "~> 2.0"

  app = {
    name                = module.naming.static_web_app.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name

    sku_tier = "Standard"
    sku_size = "Standard"

    tags = {
      "hidden-link:${module.appi.insights.id}" = "Resource"
    }

    app_settings = {
      "APPINSIGHTS_INSTRUMENTATIONKEY"        = module.appi.insights.instrumentation_key
      "APPLICATIONINSIGHTS_CONNECTION_STRING" = module.appi.insights.connection_string
    }
  }
}
