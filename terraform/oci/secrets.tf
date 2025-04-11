# terraform/oci/secrets.tf

# === Fetch secret bundles from OCI Vault ===

data "oci_secrets_secretbundle" "cloudflare_api_token" {
  secret_id = var.cloudflare_api_token_secret_id
}

data "oci_secrets_secretbundle" "cloudflare_zone_id" {
  secret_id = var.cloudflare_zone_id_secret_id
}

data "oci_secrets_secretbundle" "jenkins_volume_ocid" {
  secret_id = var.jenkins_volume_ocid_secret_id
}

data "oci_secrets_secretbundle" "ssh_public_key" {
  secret_id = var.ssh_public_key_secret_id
}

# === Decoded secret values available as locals ===

locals {
  cloudflare_api_token = base64decode(data.oci_secrets_secretbundle.cloudflare_api_token.secret_bundle_content[0].content)
  cloudflare_zone_id   = base64decode(data.oci_secrets_secretbundle.cloudflare_zone_id.secret_bundle_content[0].content)
  jenkins_volume_ocid  = base64decode(data.oci_secrets_secretbundle.jenkins_volume_ocid.secret_bundle_content[0].content)
  ssh_public_key       = base64decode(data.oci_secrets_secretbundle.ssh_public_key.secret_bundle_content[0].content)
}