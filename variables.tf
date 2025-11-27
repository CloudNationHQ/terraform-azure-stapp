variable "instance" {
  description = "Contains all static web app configuration"
  type = object({
    name                               = string
    resource_group_name                = optional(string)
    location                           = optional(string)
    sku_tier                           = optional(string, "Standard")
    sku_size                           = optional(string, "Standard")
    app_settings                       = optional(map(string))
    configuration_file_changes_enabled = optional(bool, true)
    preview_environments_enabled       = optional(bool, true)
    public_network_access_enabled      = optional(bool, true)
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
    condition     = var.instance.repository_url == null || (var.instance.repository_token != null && var.instance.repository_branch != null)
    error_message = "When repository_url is set, both repository_token and repository_branch must be provided."
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
