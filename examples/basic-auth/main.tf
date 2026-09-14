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

resource "random_password" "password" {
  length      = 24
  special     = true
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
  min_special = 1
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

    basic_auth = {
      environments = "StagingEnvironments"
      password     = random_password.password.result
    }
  }
}
