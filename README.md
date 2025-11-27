# Static Web App

This Terraform module simplifies the deployment and management of azure static web apps, offering customizable configurations for hosting modern web applications.

## Features

Supports multiple custom domains.

Enables function app backend registrations

Includes managed identity configuration

Supports basic authentication for environments

Enables private endpoint integration

Supports application insights monitoring

Utilization of terratest for robust validation

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 4.0)

## Resources

The following resources are used by this module:

- [azurerm_static_web_app.stapp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/static_web_app) (resource)
- [azurerm_static_web_app_custom_domain.domains](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/static_web_app_custom_domain) (resource)
- [azurerm_static_web_app_function_app_registration.function_app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/static_web_app_function_app_registration) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_instance"></a> [instance](#input\_instance)

Description: Contains all static web app configuration

Type:

```hcl
object({
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
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_location"></a> [location](#input\_location)

Description: default azure region to be used.

Type: `string`

Default: `null`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: default resource group to be used.

Type: `string`

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: tags to be added to the resources

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_custom_domains"></a> [custom\_domains](#output\_custom\_domains)

Description: contains custom domain configurations

### <a name="output_function_app_registration"></a> [function\_app\_registration](#output\_function\_app\_registration)

Description: contains function app registration configuration

### <a name="output_instance"></a> [instance](#output\_instance)

Description: contains all static web app configuration
<!-- END_TF_DOCS -->

## Goals

For more information, please see our [goals and non-goals](./GOALS.md).

## Testing

For more information, please see our testing [guidelines](./TESTING.md)

## Notes

Using a dedicated module, we've developed a naming convention for resources that's based on specific regular expressions for each type, ensuring correct abbreviations and offering flexibility with multiple prefixes and suffixes.

Full examples detailing all usages, along with integrations with dependency modules, are located in the examples directory.

To update the module's documentation run `make doc`

## Contributors

We welcome contributions from the community! Whether it's reporting a bug, suggesting a new feature, or submitting a pull request, your input is highly valued.

For more information, please see our contribution [guidelines](./CONTRIBUTING.md). <br><br>

<a href="https://github.com/cloudnationhq/terraform-azure-stapp/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=cloudnationhq/terraform-azure-stapp" />
</a>

## License

MIT Licensed. See [LICENSE](./LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/en-us/azure/static-web-apps/)
- [Rest Api](https://learn.microsoft.com/en-us/rest/api/appservice/static-sites)
