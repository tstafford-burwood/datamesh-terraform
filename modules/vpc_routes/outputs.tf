#-------------------
# VPC ROUTES OUTPUTS
#-------------------

output "routes" {
  description = "The created routes resources"
  value       = module.vpc_routes.routes
}