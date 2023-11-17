output "deployment" {
  value       = helm_release.this.status
  description = "The status of the helm deployment"
}

#output "deployment" {
#  value       = var.app["deploy"] ? helm_release.this[0].metadata : []
#  description = "The state of the helm deployment"
#}
