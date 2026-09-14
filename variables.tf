variable "app" {
  description = "Contains all static web app configuration"
  type = object({
    name                               = string
    resource_group_name                = optional(string)
    location                           = optional(string)
    sku_tier                           = optional(string, "Standard")
    sku_size                           = optional(string, "Standard")
    app_settings                       = optional(map(string))
    configuration_file_changes_enabled = optional(bool)
    preview_environments_enabled       = optional(bool)
    public_network_access_enabled      = optional(bool)
    tags                               = optional(map(string))
    repository_url                     = optional(string)
    repository_token                   = optional(string)
    repository_branch                  = optional(string)
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))
    basic_auth = optional(object({
      environments = string
      password     = string
    }))
    custom_domains = optional(map(object({
      domain_name     = optional(string)
      validation_type = string
    })), {})
    function_app_registration = optional(object({
      function_app_id = string
    }))
  })

  validation {
    condition     = var.app.repository_url == null || (var.app.repository_token != null && var.app.repository_branch != null)
    error_message = "When repository_url is set, both repository_token and repository_branch must be provided."
  }

  validation {
    condition     = lookup(var.app, "location", null) != null || var.location != null
    error_message = "location must be set on var.app.location or on the module-level var.location."
  }

  validation {
    condition     = lookup(var.app, "resource_group_name", null) != null || var.resource_group_name != null
    error_message = "resource_group_name must be set on var.app.resource_group_name or on the module-level var.resource_group_name."
  }
}

variable "location" {
  description = "default azure region to be used."
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "default resource group to be used."
  type        = string
  default     = null
}

variable "tags" {
  description = "tags to be added to the resources"
  type        = map(string)
  default     = {}
}
