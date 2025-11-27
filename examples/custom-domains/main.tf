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

module "stapp" {
  source  = "cloudnationhq/stapp/azure"
  version = "~> 1.0"

  instance = {
    name                = module.naming.static_web_app.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name

    custom_domains = {
      www = {
        domain_name     = "www-cd1.example.com"
        validation_type = "dns-txt-token"
      }
      api = {
        domain_name     = "api-cd1.example.com"
        validation_type = "dns-txt-token"
      }
      app = {
        domain_name     = "app-cd1.example.com"
        validation_type = "dns-txt-token"
      }
    }
  }
}
