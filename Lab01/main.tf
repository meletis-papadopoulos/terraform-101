# Random
resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

# Locals
locals {
  environment_prefix = "${var.application_name}-${var.environment_name}-${random_string.suffix.result}"

  # Map (collection with 2 objects)
  regional_stamps = {
    "foo" = {
      region         = "westus"
      min_node_count = 4
      max_node_count = 8
    },
    "bar" = {
      region         = "eastus"
      min_node_count = 4
      max_node_count = 8
    }
  }
}

# Modules
module "regional_stamps" {
  source   = "./modules/regional-stamp"
  for_each = local.regional_stamps

  # count  = length(local.regional_stamps)

  # Attributes
  # name          = local.regional_stamps[count.index].name
  region         = each.value.region
  name           = each.key
  min_node_count = each.value.min_node_count
  max_node_count = each.value.max_node_count
}

# List
# resource "random_string" "list" {
#   count   = length(var.regions) # Meta argument (List)
#   length  = 6
#   upper   = false
#   special = false
# }

# Map
# resource "random_string" "map" {
#   for_each = var.region_instance_count # Meta argument for (Map)
#   length   = 6
#   upper    = false
#   special  = false
# }

# Conditional check with "count" meta argument
# resource "random_string" "if" {
#   count   = var.enabled ? 1 : 0
#   length  = 6
#   upper   = false
#   special = false
# }

# Random Module (Registry)
# module "alpha" {
#   source  = "hashicorp/module/random"
#   version = "1.0.0"
# }

# Random Module (Registry)
# module "bravo" {
#   source  = "hashicorp/module/random"
#   version = "1.0.0"
# }

# Random Module (Local)
# module "charlie" {
#   source = "./modules/random"
#   length = 8
# }
