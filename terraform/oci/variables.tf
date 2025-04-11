# === DNS STRUCTURE ===
variable "domain_name" {
  type        = string
  description = "Base domain name used for DNS records (e.g., pauloazedo.dev)"
  default     = "pauloazedo.dev"
}

variable "dns_prefix" {
  type        = string
  description = "Cloud provider or environment prefix (e.g., oci, aws, azure)"
  default     = "oci"
}

# === USER-DEFINED VARIABLES (Non-sensitive) ===
variable "jenkins_volume_device" {
  type        = string
  default     = "/dev/oracleoci/oraclevdb"
  description = "Linux device path where the Jenkins block volume will be attached"
}

# === OCI Provider Region ===
variable "region" {
  type        = string
  description = "OCI region (e.g., us-ashburn-1)"
  default     = "us-ashburn-1"
}

# === OCI Vault Secret OCIDs (passed from terraform.tfvars or env) ===
variable "cloudflare_api_token_secret_id" {
  type        = string
  description = "OCI Vault Secret OCID for Cloudflare API token"
}

variable "cloudflare_zone_id_secret_id" {
  type        = string
  description = "OCI Vault Secret OCID for Cloudflare zone ID"
}

variable "ssh_public_key_secret_id" {
  type        = string
  description = "OCI Vault Secret OCID for SSH public key"
}

variable "jenkins_volume_ocid_secret_id" {
  type        = string
  description = "OCI Vault Secret OCID for Jenkins block volume OCID"
}