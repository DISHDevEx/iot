#Variables
#
variable "vault_address" {
  description = "Vault server address"
  type        = string
  default     = null
  sensitive   = true
}
variable "vault_token" {
  description = "Vault server token"
  type        = string
  default     = null
  sensitive   = true
}
variable "vault_secrets_path" {
  description = "Secrets path in Hashicorp Vault"
  type        = string
  default     = null
  sensitive   = true
}
