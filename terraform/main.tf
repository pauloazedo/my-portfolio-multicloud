terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 5.0.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 3.0.0"
    }
  }

  required_version = ">= 1.4.0"
}

provider "oci" {
  region           = var.region
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# === AVAILABILITY DOMAINS ===
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

# === COMPARTMENT ===
resource "oci_identity_compartment" "devops_portfolio" {
  name          = "DevOpsPortfolioCompartmentV5"
  description   = "Compartment for OCI DevOps portfolio project"
  enable_delete = true

  defined_tags = {
    "Oracle-Tags.CreatedBy" = "Terraform"
  }
}

# === VCN ===
resource "oci_core_virtual_network" "vcn" {
  compartment_id = oci_identity_compartment.devops_portfolio.id
  display_name   = "devops-vcn"
  cidr_block     = "10.0.0.0/16"
  dns_label      = "devopsvcn"
}

# === INTERNET GATEWAY ===
resource "oci_core_internet_gateway" "igw" {
  compartment_id = oci_identity_compartment.devops_portfolio.id
  display_name   = "devops-igw"
  vcn_id         = oci_core_virtual_network.vcn.id
}

# === ROUTE TABLE ===
resource "oci_core_route_table" "rt" {
  compartment_id = oci_identity_compartment.devops_portfolio.id
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "devops-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.igw.id
  }
}

# === NETWORK SECURITY GROUP ===
resource "oci_core_network_security_group" "nsg" {
  compartment_id = oci_identity_compartment.devops_portfolio.id
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "devops-nsg"
}

# === NSG RULES ===
resource "oci_core_network_security_group_security_rule" "allow_ssh" {
  network_security_group_id = oci_core_network_security_group.nsg.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source_type               = "CIDR_BLOCK"
  source                    = "0.0.0.0/0"

  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }

  description = "Allow SSH"
}

resource "oci_core_network_security_group_security_rule" "allow_http" {
  network_security_group_id = oci_core_network_security_group.nsg.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source_type               = "CIDR_BLOCK"
  source                    = "0.0.0.0/0"

  tcp_options {
    destination_port_range {
      min = 80
      max = 80
    }
  }

  description = "Allow HTTP"
}

resource "oci_core_network_security_group_security_rule" "allow_https" {
  network_security_group_id = oci_core_network_security_group.nsg.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source_type               = "CIDR_BLOCK"
  source                    = "0.0.0.0/0"

  tcp_options {
    destination_port_range {
      min = 443
      max = 443
    }
  }

  description = "Allow HTTPS"
}