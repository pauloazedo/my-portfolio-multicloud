# === PROD SUBNET ===
resource "oci_core_subnet" "prod_subnet" {
  compartment_id             = oci_identity_compartment.devops_portfolio.id
  vcn_id                     = oci_core_virtual_network.vcn.id
  cidr_block                 = "10.0.2.0/24"
  display_name               = "prod-subnet"
  route_table_id             = oci_core_route_table.rt.id
  dns_label                  = "prod"
  prohibit_public_ip_on_vnic = false
}

# === PROD INSTANCE ===
resource "oci_core_instance" "prod" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = oci_identity_compartment.devops_portfolio.id
  display_name        = "prod-instance"
  shape               = "VM.Standard.A1.Flex"

  shape_config {
    ocpus         = 2
    memory_in_gbs = 12
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.prod_subnet.id
    assign_public_ip = true
    hostname_label   = "prod"
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key_path)
    user_data = base64encode(<<-EOT
      #cloud-config
      users:
        - name: devops
          groups: sudo
          shell: /bin/bash
          sudo: ALL=(ALL) NOPASSWD:ALL
          ssh_authorized_keys:
            - ${file(var.ssh_public_key_path)}
    EOT
    )
  }

  source_details {
    source_type = "image"
    source_id   = "ocid1.image.oc1.iad.aaaaaaaahga37ytba47p2msqzbh5erbqvniyybcvteuh646vgyw4tltustka"
  }
}

# === VNIC ATTACHMENT LOOKUP ===
data "oci_core_vnic_attachments" "prod" {
  compartment_id      = oci_identity_compartment.devops_portfolio.id
  instance_id         = oci_core_instance.prod.id
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
}

# === VNIC DETAILS ===
data "oci_core_vnic" "prod" {
  vnic_id = data.oci_core_vnic_attachments.prod.vnic_attachments[0].vnic_id
}

# === CLOUDFLARE DNS RECORD FOR PROD ===
resource "cloudflare_dns_record" "prod" {
  zone_id = var.cloudflare_zone_id
  name    = "prod"
  type    = "A"
  content = data.oci_core_vnic.prod.public_ip_address
  ttl     = 300
  proxied = false
}

# === Attach NSG to VNIC ===
resource "null_resource" "attach_nsg_to_prod_vnic" {
  triggers = {
    vnic_id = data.oci_core_vnic.prod.id
    nsg_id  = oci_core_network_security_group.nsg.id
  }

  provisioner "local-exec" {
    command = <<EOT
      oci network vnic update \
        --vnic-id "${self.triggers.vnic_id}" \
        --nsg-ids '["${self.triggers.nsg_id}"]' \
        --force \
        --profile DEVOPS
EOT
  }
}