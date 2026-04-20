<!-- BADGES:START -->
[![CI](https://github.com/POps-Rox/tf-az-overlays-datafactory/actions/workflows/ci.yml/badge.svg)](https://github.com/POps-Rox/tf-az-overlays-datafactory/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/POps-Rox/tf-az-overlays-datafactory/pulls)
[![Maintained](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/POps-Rox/tf-az-overlays-datafactory/graphs/commit-activity)
[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.5-623CE4.svg?logo=terraform)](https://www.terraform.io)
<!-- BADGES:END -->

# Azure Data Factory Overlay

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/POps-Rox/overlays-datafactory/azurerm/)

This Overlay terraform module can create a Azure Data Factory and manage related parameters to be used in a [SCCA compliant Network](https://registry.terraform.io/modules/POps-Rox/overlays-management-hub/azurerm/latest).

## SCCA Compliance

This module can be SCCA compliant and can be used in a SCCA compliant Network. Enable private endpoints and SCCA compliant network rules to make it SCCA compliant.

For more information, please read the [SCCA documentation]("https://www.cisa.gov/secure-cloud-computing-architecture").

## Contributing

If you want to contribute to this repository, feel free to to contribute to our Terraform module.

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

## Using Azure Clouds

Since this module is built for both public and us government clouds. The `environment` variable defaults to `public` for Azure Cloud. When using this module with the Azure Government Cloud, you must set the `environment` variable to `usgovernment`. You will also need to set the azurerm provider `environment` variable to the proper cloud as well. This will ensure that the correct Azure Government Cloud endpoints are used. You will also need to set the `location` variable to a valid Azure Government Cloud location.

Example Usage for Azure Government Cloud:

```hcl

provider "azurerm" {
  environment = "usgovernment"
}

module "overlays-datafactory" {
  source  = "POps-Rox/tf-az-overlays-datafactory/azurerm"
  version = "2.0.0"
  
  location = "usgovvirginia"
  environment = "usgovernment"
  ...
}

```

## Resources Used

- [Azure Data Factory](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory)
- [Azure Data Factory Integration Runtime Azure](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_integration_runtime_azure)
- [Azure Data Factory Integration Runtime Azure SSIS](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_integration_runtime_azure_ssis)
- [Azure Data Factory Integration Runtime Self Hosted](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_integration_runtime_self_hosted)
- [Azure Private DNS Zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone)
- [Azure Private DNS Zone Virtual Network Link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link)
- [Azure Private Endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint)
- [Azure Private Endpoint Connection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint_connection)

## Module Usage

```hcl
# Azurerm Provider configuration
provider "azurerm" {
  features {}
}

module "mod_datafactory" {
  source  = "POps-Rox/tf-az-overlays-datafactory/azurerm"
  version = "x.x.x"
  
  # By default, this module will create a resource group and 
  # provide a name for an existing resource group. If you wish 
  # to use an existing resource group, change the option 
  # to "create_datafactory_resource_group = false." The location of the group 
  # will remain the same if you use the current resource.
  existing_resource_group_name = azurerm_resource_group.datafactory_rg.name
  location                     = module.mod_azure_region_lookup.location_cli
  environment                  = var.environment
  deploy_environment           = var.deploy_environment
  org_name                     = var.org_name
  workload_name                = var.workload_name

}
```

## Optional Features

Data Factory Overlay has optional features that can be enabled by setting parameters on the deployment.

### Create resource group

By default, this module will create a resource group and the name of the resource group to be given in an argument `existing_resource_group_name`. If you want to use an existing resource group, specify the existing resource group name, and set the argument to `create_datafactory_resource_group = false`.

> *If you are using an existing resource group, then this module uses the same resource group location to create all resources in this module.*

### Azure Runtime

This module can be used with the [Azure Data Factory Integration Runtime Azure](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_integration_runtime_azure). To use this feature, you must specify the `azure_integration_runtime` variable. The `azure_integration_runtime` variable is a map object that defines any Azure Integration Runtime nodes that are required. The key of each object is the name of a new node.

```hcl

# Azurerm Provider configuration
provider "azurerm" {
  features {}
}

module "mod_datafactory" {
  source  = "POps-Rox/tf-az-overlays-datafactory/azurerm"
  version = "x.x.x

  ---Left out for brevity---

azure_integration_runtime = {
  az-ir-co-01 {
    "compute_type" .  = "ComputeOptimized"
    "cleanup_enabled" = true
    core_count        = 16
  },
  az-ir-gen-01 {},
  az-ir-gen-02 {},
}

}
```

### Self Hosted Runtime

This module can be used with the [Azure Data Factory Integration Runtime Self Hosted](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_integration_runtime_self_hosted). To use this feature, you must specify the `selfhosted_integration_runtime` variable. The `selfhosted_integration_runtime` variable is a map object that defines any Self Hosted Integration Runtime nodes that are required. The key of each object is the name of a new node.

```hcl

# Azurerm Provider configuration
provider "azurerm" {
  features {}
}

module "mod_datafactory" {
  source  = "POps-Rox/tf-az-overlays-datafactory/azurerm"
  version = "x.x.x

  ---Left out for brevity---

selfhosted_integration_runtime = {
  sh-ir-co-01 {
    "description" = "Self Hosted Integration Runtime"  
  },
  sh-ir-gen-01 {},
  sh-ir-gen-02 {},
}

}
```

### Azure SSIS Runtime

This module can be used with the [Azure Data Factory Integration Runtime Azure SSIS](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_integration_runtime_azure_ssis). To use this feature, you must specify the `azure_ssis_integration_runtime` variable. The `azure_ssis_integration_runtime` variable is a map object that defines any Azure SSIS Integration Runtime nodes that are required. The key of each object is the name of a new node.

```terraform

# Azurerm Provider configuration
provider "azurerm" {
  features {}
}

module "mod_datafactory" {
  source  = "POps-Rox/tf-az-overlays-datafactory/azurerm"
  version = "x.x.x

  ---Left out for brevity---

azure_ssis_integration_runtime = {
  az-ssis-ir-co-01 {
    "node_size"                        = "Standard_D4_v3"
    "number_of_nodes"                  = 1
    "max_parallel_executions_per_node" = 1
    "edition"                          = "Standard"
    "license_type"                     = "LicenseIncluded"
  },
  az-ssis-ir-gen-01 {},
  az-ssis-ir-gen-02 {},
}

}
```

### Private Endpoint

This module can be used with the [Private Endpoint Module](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) to create private endpoints for the Data Factory. To use this module with private endpoints, you must set the `enable_private_endpoint` variable to `true`. You must also provide the `existing_virtual_network_name` and `existing_private_subnet_name` variables. This will create a private endpoint connection to the Data Factory. You can also provide the `existing_dev_private_dns_zone` and `existing_sql_private_dns_zone` variables to use existing private DNS zones for the Data Factory. If you do not provide these variables, the module will create private DNS zones for the Data Factory workspace.

```terraform
# Azurerm Provider configuration
provider "azurerm" {
  features {}
}

module "mod_datafactory" {
  source  = "POps-Rox/tf-az-overlays-datafactory/azurerm"
  version = "x.x.x"

  # The following variables are used to create a private endpoint connection
  enable_private_endpoint       = true
  existing_virtual_network_name = azurerm_virtual_network.datafactory_vnet.name
  existing_private_subnet_name  = azurerm_subnet.datafactory_subnet.name
  existing_dev_private_dns_zone = "privatelink.dev.azuredatafactory.net"
  existing_sql_private_dns_zone = "privatelink.sql.azuredatafactory.net"
}
```

## Resource Locks

This module can be used with the [Resource Lock Module](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) to create resource locks for the Synapse workspace.

## Recommended naming and tagging conventions

Applying tags to your Azure resources, resource groups, and subscriptions to logically organize them into a taxonomy. Each tag consists of a name and a value pair. For example, you can apply the name `Environment` and the value `Production` to all the resources in production.
For recommendations on how to implement a tagging strategy, see Resource naming and tagging decision guide.

>**Important** :
Tag names are case-insensitive for operations. A tag with a tag name, regardless of the casing, is updated or retrieved. However, the resource provider might keep the casing you provide for the tag name. You'll see that casing in cost reports. **Tag values are case-sensitive.**

An effective naming convention assembles resource names by using important resource information as parts of a resource's name. For example, using these [recommended naming conventions](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging#example-names), a public IP resource for a production SharePoint workload is named like this: `pip-sharepoint-prod-westus-001`.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9 |
| <a name="requirement_popsrox-utils"></a> [popsrox-utils](#requirement\_popsrox-utils) | ~> 1.0.4 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.116 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_popsrox-utils"></a> [popsrox-utils](#provider\_popsrox-utils) | ~> 1.0.4 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.116 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_mod_azure_region_lookup"></a> [mod\_azure\_region\_lookup](#module\_mod\_azure\_region\_lookup) | POps-Rox/overlays-azregions-lookup/azurerm | ~> 1.0.0 |
| <a name="module_mod_scaffold_rg"></a> [mod\_scaffold\_rg](#module\_mod\_scaffold\_rg) | POps-Rox/overlays-resource-group/azurerm | ~> 1.0.1 |

## Resources

| Name | Type |
|------|------|
| [azurerm_data_factory.main_data_factory](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory) | resource |
| [azurerm_data_factory_integration_runtime_azure.integration_runtime](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_integration_runtime_azure) | resource |
| [azurerm_data_factory_integration_runtime_azure_ssis.integration_runtime](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_integration_runtime_azure_ssis) | resource |
| [azurerm_data_factory_integration_runtime_self_hosted.integration_runtime](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_integration_runtime_self_hosted) | resource |
| [azurerm_management_lock.data_factory_level_lock](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_management_lock.resource_group_level_lock](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_private_dns_a_record.a_rec](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_zone.dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.vnet_link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_endpoint.pep](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [popsrox_resource_name.data_factory_name](https://registry.terraform.io/providers/POps-Rox/popsrox-utils/latest/docs/data-sources/resource_name) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_private_endpoint_connection.pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_endpoint_connection) | data source |
| [azurerm_resource_group.rgrp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.snet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_add_tags"></a> [add\_tags](#input\_add\_tags) | Map of custom tags. | `map(string)` | `{}` | no |
| <a name="input_azure_devops_configuration"></a> [azure\_devops\_configuration](#input\_azure\_devops\_configuration) | Azure DevOps configuration for data factory. See documentation at <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory#vsts_configuration> | `map(string)` | `null` | no |
| <a name="input_azure_integration_runtime"></a> [azure\_integration\_runtime](#input\_azure\_integration\_runtime) | Map Object to define any Azure Integration Runtime nodes that required.<br>  key of each object is the name of a new node.<br>  configuration parameters within the object allow customisation.<br>  EXAMPLE:<br>  azure\_integration\_runtime = {<br>    az-ir-co-01 {<br>      "compute\_type" .  = "ComputeOptimized"<br>      "cleanup\_enabled" = true<br>      core\_count        = 16<br>    },<br>    az-ir-gen-01 {},<br>    az-ir-gen-02 {},<br>  } | <pre>map(object({<br>    description             = optional(string, "Azure Integrated Runtime")<br>    compute_type            = optional(string, "General")<br>    virtual_network_enabled = optional(string, true)<br>    core_count              = optional(number, 8)<br>    time_to_live_min        = optional(number, 0)<br>    cleanup_enabled         = optional(bool, true)<br>  }))</pre> | `{}` | no |
| <a name="input_azure_ssis_integration_runtime"></a> [azure\_ssis\_integration\_runtime](#input\_azure\_ssis\_integration\_runtime) | Map Object to define any Azure SSIS Integration Runtime nodes that required.<br>  key of each object is the name of a new node.<br>  configuration parameters within the object allow customisation.<br>  EXAMPLE:<br>  azure\_ssis\_integration\_runtime = {<br>    az-ssis-ir-co-01 {<br>      "node\_size"                        = "Standard\_D4\_v3"<br>      "number\_of\_nodes"                  = 1<br>      "max\_parallel\_executions\_per\_node" = 1<br>      "edition"                          = "Standard"<br>      "license\_type"                     = "LicenseIncluded"<br>    },<br>    az-ssis-ir-gen-01 {},<br>    az-ssis-ir-gen-02 {},<br>  } | <pre>map(object({<br>    description                      = optional(string, "Azure SSIS Integration Runtime")<br>    node_size                        = optional(string, "Standard_D4_v3")<br>    number_of_nodes                  = optional(number, 1)<br>    max_parallel_executions_per_node = optional(number, 1)<br>    edition                          = optional(string, "Standard")<br>    license_type                     = optional(string, "LicenseIncluded")<br>  }))</pre> | `{}` | no |
| <a name="input_create_data_factory_resource_group"></a> [create\_data\_factory\_resource\_group](#input\_create\_data\_factory\_resource\_group) | Create a resource group for the data factory. If set to false, the existing\_resource\_group\_name variable must be set. Default is false. | `bool` | `false` | no |
| <a name="input_custom_data_factory_name"></a> [custom\_data\_factory\_name](#input\_custom\_data\_factory\_name) | Custom name of the Data Factory, generated if not set. | `string` | `null` | no |
| <a name="input_custom_resource_group_name"></a> [custom\_resource\_group\_name](#input\_custom\_resource\_group\_name) | Custom name of the resource group, generated if not set. | `string` | `null` | no |
| <a name="input_default_tags_enabled"></a> [default\_tags\_enabled](#input\_default\_tags\_enabled) | Option to enable or disable default tags. | `bool` | `true` | no |
| <a name="input_deploy_environment"></a> [deploy\_environment](#input\_deploy\_environment) | Name of the workload's environment | `string` | n/a | yes |
| <a name="input_enable_private_endpoint"></a> [enable\_private\_endpoint](#input\_enable\_private\_endpoint) | Manages a Private Endpoint to Azure Container Registry. Default is false. | `bool` | `false` | no |
| <a name="input_enable_resource_locks"></a> [enable\_resource\_locks](#input\_enable\_resource\_locks) | (Optional) Enable resource locks, default is false. If true, resource locks will be created for the resource group and the storage account. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The Terraform backend environment e.g. public or usgovernment | `string` | n/a | yes |
| <a name="input_existing_private_dns_zone"></a> [existing\_private\_dns\_zone](#input\_existing\_private\_dns\_zone) | Name of the existing private DNS zone | `any` | `null` | no |
| <a name="input_existing_private_subnet_name"></a> [existing\_private\_subnet\_name](#input\_existing\_private\_subnet\_name) | Name of the existing subnet for the private endpoint | `any` | `null` | no |
| <a name="input_existing_resource_group_name"></a> [existing\_resource\_group\_name](#input\_existing\_resource\_group\_name) | The name of the existing resource group to use. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables. | `string` | `null` | no |
| <a name="input_existing_virtual_network_name"></a> [existing\_virtual\_network\_name](#input\_existing\_virtual\_network\_name) | Name of the virtual network for the private endpoint | `any` | `null` | no |
| <a name="input_github_configuration"></a> [github\_configuration](#input\_github\_configuration) | Github configuration for data factory. See documentation at <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory#github_configuration> | `map(string)` | `null` | no |
| <a name="input_global_parameters"></a> [global\_parameters](#input\_global\_parameters) | Global parameters for data factory. See documentation at <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory#global_parameter> | `list(map(string))` | `[]` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | Specifies a list of User Assigned Managed Identity IDs to be assigned to this Storage Account. | `list(string)` | `null` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | Specifies the type of Managed Service Identity that should be configured on this Storage Account. Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned` (to enable both). | `string` | `"SystemAssigned"` | no |
| <a name="input_integration_runtime_custom_name"></a> [integration\_runtime\_custom\_name](#input\_integration\_runtime\_custom\_name) | Name of the integration\_runtime resource | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region in which instance will be hosted | `string` | n/a | yes |
| <a name="input_lock_level"></a> [lock\_level](#input\_lock\_level) | (Optional) id locks are enabled, Specifies the Level to be used for this Lock. | `string` | `"CanNotDelete"` | no |
| <a name="input_managed_virtual_network_enabled"></a> [managed\_virtual\_network\_enabled](#input\_managed\_virtual\_network\_enabled) | True to enable managed virtual network | `bool` | `true` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Optional prefix for the generated name | `string` | `""` | no |
| <a name="input_name_suffix"></a> [name\_suffix](#input\_name\_suffix) | Optional suffix for the generated name | `string` | `""` | no |
| <a name="input_org_name"></a> [org\_name](#input\_org\_name) | Name of the organization | `string` | n/a | yes |
| <a name="input_public_network_enabled"></a> [public\_network\_enabled](#input\_public\_network\_enabled) | True to make data factory visible to the public network | `bool` | `false` | no |
| <a name="input_selfhosted_integration_runtime"></a> [selfhosted\_integration\_runtime](#input\_selfhosted\_integration\_runtime) | Map Object to define any Self Hosted Integration Runtime nodes that required.<br>  key of each object is the name of a new node.<br>  configuration parameters within the object allow customisation.<br>  EXAMPLE:<br>  selfhosted\_integration\_runtime = {<br>    sh-ir-co-01 {<br>      "description" = "Self Hosted Integration Runtime"  <br>    },<br>    sh-ir-gen-01 {},<br>    sh-ir-gen-02 {},<br>  } | <pre>map(object({<br>    description = optional(string, "Self Hosted Integration Runtime")<br>  }))</pre> | `{}` | no |
| <a name="input_use_location_short_name"></a> [use\_location\_short\_name](#input\_use\_location\_short\_name) | Use short location name for resources naming (ie eastus -> eus). Default is true. If set to false, the full cli location name will be used. if custom naming is set, this variable will be ignored. | `bool` | `true` | no |
| <a name="input_use_naming"></a> [use\_naming](#input\_use\_naming) | Use the Azure NoOps naming provider to generate default resource name. `storage_account_custom_name` override this if set. Legacy default name is used if this is set to `false`. | `bool` | `true` | no |
| <a name="input_workload_name"></a> [workload\_name](#input\_workload\_name) | Name of the workload\_name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_data_factory_id"></a> [data\_factory\_id](#output\_data\_factory\_id) | Data factory id |
| <a name="output_data_factory_location"></a> [data\_factory\_location](#output\_data\_factory\_location) | Data factory location |
| <a name="output_data_factory_managed_identity"></a> [data\_factory\_managed\_identity](#output\_data\_factory\_managed\_identity) | Type of managed identity |
| <a name="output_data_factory_name"></a> [data\_factory\_name](#output\_data\_factory\_name) | Data factory name |
| <a name="output_data_factory_resource_group_name"></a> [data\_factory\_resource\_group\_name](#output\_data\_factory\_resource\_group\_name) | Data factory resource group name |
| <a name="output_global_paramaters"></a> [global\_paramaters](#output\_global\_paramaters) | A map showing any created Global Parameters. |
<!-- END_TF_DOCS -->