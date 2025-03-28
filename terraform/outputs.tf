# === INSTANCE PUBLIC IP ADDRESSES ===

output "uat_instance_public_ip" {
  value       = data.oci_core_vnic.uat.public_ip_address
  description = "Public IP of the UAT instance"
}

output "prod_instance_public_ip" {
  value       = data.oci_core_vnic.prod.public_ip_address
  description = "Public IP of the Production instance"
}

# === INSTANCE DISPLAY NAMES ===

output "uat_instance_display_name" {
  value       = oci_core_instance.uat.display_name
  description = "Name of the UAT instance"
}

output "prod_instance_display_name" {
  value       = oci_core_instance.prod.display_name
  description = "Name of the Production instance"
}

# === VCN INFORMATION ===

output "vcn_id" {
  value       = oci_core_virtual_network.vcn.id
  description = "VCN OCID used for the project"
}

# === DNS RECORDS ===

output "uat_dns_record" {
  value       = "uat.pauloazedo.us"
  description = "Public DNS record for UAT"
}

output "prod_dns_record" {
  value       = "prod.pauloazedo.us"
  description = "Public DNS record for Production"
}

output "jenkins_dns_record" {
  value       = "jenkins.pauloazedo.us"
  description = "Public DNS record for Jenkins (on UAT)"
}