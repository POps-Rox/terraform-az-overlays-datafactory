# Changelog

## [2.0.0] - 2026-05-12

### ⚠️ Breaking Changes

- Upgraded `hashicorp/azurerm` provider from `~> 3.116` to `~> 4.20`.
- Minimum Terraform CLI version raised from `>= 1.9` to `>= 1.10`.
- `azurerm_subnet.private_endpoint_network_policies_enabled = false` →
  `azurerm_subnet.private_endpoint_network_policies = "Disabled"` in
  `examples/Government/basic_existing_rg_selfhosted_runtime/dependencies.tf`.
  azurerm 4.x replaced the bool argument with a string enum.

### Behavior Notes

- `azurerm_data_factory` `github_configuration` and `vsts_configuration`
  blocks were audited against the azurerm 4.x schema; their argument
  shapes (`account_name`, `branch_name`, `git_url`, `repository_name`,
  `root_folder`, `project_name`, `tenant_id`) are unchanged in 4.x.
  No code change was required, but pre-flight notes flagged this area
  for verification.
- `azurerm_data_factory_integration_runtime_*` resources continue to
  use `data_factory_id` (not `data_factory_name` + `resource_group_name`)
  — already on the 4.x shape from a prior cleanup.

### Migration Notes for Consumers

- Bump your root `azurerm` provider constraint to `~> 4.20`.
- Ensure Terraform CLI `>= 1.10`.
- Set `ARM_SUBSCRIPTION_ID` env var or `subscription_id` in your
  `provider "azurerm"` block — azurerm 4.x requires it.
- The `skip_provider_registration = true` setting was removed from
  example `provider "azurerm"` blocks (argument removed in 4.x).
  The functional replacement is `resource_provider_registrations =
  "none"` (or `"core"` / `"all"`), which is opt-in and not required
  for `init`/`validate`.
- Module public input/output surface is unchanged.

### Added

- `azapi ~> 2.0` provider declaration in `versions.tf` (root + every
  example).
- Complete `terraform {}` block in each example `versions.tf` (was a
  provider-only file previously, leaving azurerm un-pinned per example).

### Removed

- `skip_provider_registration = true` lines from
  `examples/{Commercial,Government}/basic_existing_rg_*_runtime/versions.tf`
  (argument removed in azurerm 4.x).

### Internal

- Standardized `versions.tf` format across root and all examples.
- Bumped `required_version` to `>= 1.10` everywhere.

### Cross-module dependency

This module sources two sibling overlays from GitHub
(`tf-az-overlays-azregionslookup`, `tf-az-overlays-resourcegroup`)
which are still pinned to `azurerm ~> 3.116`. Production consumers
must wait for those overlays' Phase 1 PRs to merge before this
`2.0.0` can be cleanly initialized. Local validation was performed by
patching the cached `versions.tf` of those submodules during
`terraform init -get=false`.

# v1.0.0 - <date>

Added
- Add Something you added
