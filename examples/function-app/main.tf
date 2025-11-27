module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.25"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "westeurope"
    }
  }
}

module "storage" {
  source  = "cloudnationhq/sa/azure"
  version = "~> 4.0"

  storage = {
    name                = module.naming.storage_account.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
  }
}

module "service_plan" {
  source  = "cloudnationhq/plan/azure"
  version = "~> 3.0"

  plans = {
    plan1 = {
      name                = module.naming.app_service_plan.name
      resource_group_name = module.rg.groups.demo.name
      location            = module.rg.groups.demo.location
      os_type             = "Windows"
      sku_name            = "B1"
    }
  }
}

module "function_app" {
  source  = "cloudnationhq/func/azure"
  version = "~> 2.0"

  resource_group_name = module.rg.groups.demo.name
  location            = module.rg.groups.demo.location

  instance = {
    type                       = "windows"
    name                       = "func-demo-dev-fa1"
    location                   = module.rg.groups.demo.location
    storage_account_name       = module.storage.account.name
    storage_account_access_key = module.storage.account.primary_access_key
    service_plan_id            = module.service_plan.plans.plan1.id

    app_settings = {
      "WEBSITE_RUN_FROM_PACKAGE"        = "1"
      "WEBSITE_ENABLE_SYNC_UPDATE_SITE" = "true"
      "FUNCTIONS_WORKER_RUNTIME"        = "dotnet-isolated"
    }

    site_config = {
      always_on     = true
      http2_enabled = false
      application_stack = {
        use_dotnet_isolated_runtime = true
        dotnet_version              = "v8.0"
      }
    }
  }
}

module "stapp" {
  source  = "cloudnationhq/stapp/azure"
  version = "~> 1.0"

  instance = {
    name                = module.naming.static_web_app.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name

    function_app_registration = {
      function_app_id = module.function_app.instance.id
    }
  }
}
