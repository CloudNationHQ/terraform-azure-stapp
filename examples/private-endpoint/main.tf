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

module "network" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 9.0"

  naming = local.naming

  vnet = {
    name                = module.naming.virtual_network.name
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
    address_space       = ["10.18.0.0/16"]

    subnets = {
      endpoints = {
        address_prefixes = ["10.18.1.0/24"]
      }
    }
  }
}

module "private_dns" {
  source  = "cloudnationhq/pdns/azure"
  version = "~> 4.0"

  resource_group_name = module.rg.groups.demo.name

  zones = {
    private = {
      staticsites = {
        name = "privatelink.azurestaticapps.net"
        virtual_network_links = {
          link1 = {
            virtual_network_id = module.network.vnet.id
          }
        }
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
  }
}

module "privatelink" {
  source  = "cloudnationhq/pe/azure"
  version = "~> 2.0"

  resource_group_name = module.rg.groups.demo.name
  location            = module.rg.groups.demo.location

  endpoints = {
    stapp = {
      name      = module.naming.private_endpoint.name
      subnet_id = module.network.subnets.endpoints.id

      private_dns_zone_group = {
        private_dns_zone_ids = [module.private_dns.private_zones.staticsites.id]
      }

      private_service_connection = {
        private_connection_resource_id = module.stapp.instance.id
        subresource_names              = ["staticSites"]
      }
    }
  }
}
