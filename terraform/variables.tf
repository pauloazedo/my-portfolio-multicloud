# === OCI VARIABLES ===

variable "tenancy_ocid" {
  type        = string
  description = "The OCID of the tenancy"
}

variable "user_ocid" {
  type        = string
  description = "The OCID of the user running Terraform"
}

variable "fingerprint" {
  type        = string
  description = "API key fingerprint for the user"
}

variable "private_key_path" {
  type        = string
  description = "Local path to the OCI API private key"
}

variable "region" {
  type        = string
  description = "OCI region to deploy resources in (e.g., us-ashburn-1)"
}

# === CLOUDFLARE VARIABLES ===

variable "cloudflare_api_token" {
  type        = string
  description = "API token to manage Cloudflare DNS records"
}

variable "cloudflare_zone_id" {
  type        = string
  description = "Zone ID for the oci.pauloazedo.dev domain in Cloudflare"
}

# === SSH KEY ===

variable "ssh_public_key_path" {
  type        = string
  description = "Path to the public SSH key to inject into OCI instances"
}

# === JENKINS VOLUME ===

variable "jenkins_volume_ocid" {
  type        = string
  description = "OCID of the pre-created OCI Block Volume used for Jenkins data"
}

variable "jenkins_volume_device" {
  type        = string
  default     = "/dev/oracleoci/oraclevdb"
  description = "Linux device path to attach Jenkins block volume"
}
