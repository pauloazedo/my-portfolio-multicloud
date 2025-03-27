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
  availability_domain = "PFeQ:US-ASHBURN-AD-2"
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
    source_id   = "ocid1.image.oc1.iad.aaaaaaaawvs4xn6dfl6oo45o2ntziecjy2cbet2mlidvx3ji62oi3jai4u5a"
    boot_volume_size_in_gbs = 55
  }

  # === Add remote-exec provisioner to install Python 3.7 ===
  provisioner "remote-exec" {
    inline = [
      "sudo dnf update -y",               # Update all packages
      "sudo dnf install -y python3.11",     # Install Python 3.11
      "python3 --version"                # Verify Python version
    ]
    connection {
      type        = "ssh"
      user        = "opc"  # Use the user configured for your instance
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }
}

# === VNIC ATTACHMENT LOOKUP ===
data "oci_core_vnic_attachments" "prod" {
  compartment_id      = oci_identity_compartment.devops_portfolio.id
  instance_id         = oci_core_instance.prod.id
  availability_domain = "PFeQ:US-ASHBURN-AD-2"
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