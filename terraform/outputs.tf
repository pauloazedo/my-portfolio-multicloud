# === INSTANCE PUBLIC IP ADDRESSES ===

# Outputs the public IP address of the UAT instance
output "uat_instance_public_ip" {
  value       = oci_core_instance.uat.public_ip
  description = "Public IP of the UAT instance"
}

# Outputs the public IP address of the Production instance
output "prod_instance_public_ip" {
  value       = oci_core_instance.prod.public_ip
  description = "Public IP of the Production instance"
}

# === INSTANCE DISPLAY NAMES ===

# Outputs the display name of the UAT instance (useful for referencing or scripts)
output "uat_instance_display_name" {
  value       = oci_core_instance.uat.display_name
  description = "Name of the UAT instance"
}

# Outputs the display name of the Production instance
output "prod_instance_display_name" {
  value       = oci_core_instance.prod.display_name
  description = "Name of the Production instance"
}

# === VCN INFORMATION ===

# Outputs the VCN OCID used to provision the infrastructure (useful for diagnostics or reuse)
output "vcn_id" {
  value       = oci_core_virtual_network.vcn.id
  description = "VCN OCID used for the project"
}

# === DNS RECORDS ===

# DNS A record pointing to the UAT instance (manually specified since Cloudflare manages DNS)
output "uat_dns_record" {
  value = "uat.pauloazedo.us"
}

# DNS A record pointing to the Production instance
output "prod_dns_record" {
  value = "prod.pauloazedo.us"
}

# DNS A record pointing to the Jenkins service (on the UAT server)
output "jenkins_dns_record" {
  value = "jenkins.pauloazedo.us"
}
