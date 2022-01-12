#----------------------------------------
# VPC SC REGULAR SERVICE PERIMETER MODULE
#----------------------------------------

resource "google_access_context_manager_service_perimeter" "regular_service_perimeter" {

  title          = var.regular_service_perimeter_name
  parent         = "accessPolicies/${var.parent_policy_id}"
  name           = "accessPolicies/${var.parent_policy_id}/servicePerimeters/${var.regular_service_perimeter_name}"
  description    = var.regular_service_perimeter_description
  perimeter_type = "PERIMETER_TYPE_REGULAR"

  status {
    resources           = formatlist("projects/%s", var.project_to_add_perimeter)
    access_levels       = formatlist("accessPolicies/${var.parent_policy_id}/accessLevels/%s", var.access_level_names)
    restricted_services = var.restricted_services
    vpc_accessible_services {
      enable_restriction = var.enable_restriction
      allowed_services   = var.allowed_services
    }
    dynamic "egress_policies" {
      for_each = var.egress_policies
      content {
        egress_from {
          identities    = lookup(egress_policies.value["from"], "identities", null)
          identity_type = lookup(egress_policies.value["from"], "identity_type", null)
        }
        egress_to {
          resources = formatlist("projects/%s", lookup(egress_policies.value["to"], "resources", []))
          dynamic "operations" {
            for_each = lookup(egress_policies.value["to"], "operations", [])
            content {
              service_name = operations.key
              dynamic "method_selectors" {
                for_each = merge(
                { for k, v in lookup(operations.value, "methods", {}) : v => "method" })
                content {
                  method = method_selectors.value == "method" ? method_selectors.key : ""
                }
              }
            }
          }
        }
      }
    }
  }
}