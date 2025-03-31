# === UAT SUBNET ===
resource "oci_core_subnet" "uat_subnet" {
  compartment_id             = oci_identity_compartment.devops_portfolio.id
  vcn_id                     = oci_core_virtual_network.vcn.id
  cidr_block                 = "10.0.1.0/24"
  display_name               = "uat-subnet"
  route_table_id             = oci_core_route_table.rt.id
  dns_label                  = "uat"
  prohibit_public_ip_on_vnic = false
}

# === UAT INSTANCE ===
resource "oci_core_instance" "uat" {
  availability_domain = "PFeQ:US-ASHBURN-AD-2"
  compartment_id      = oci_identity_compartment.devops_portfolio.id
  display_name        = "uat-instance"
  shape               = "VM.Standard.A1.Flex"

  create_vnic_details {
    subnet_id              = oci_core_subnet.uat_subnet.id
    display_name           = "uat-vnic"
    hostname_label         = "uat-instance"
    assign_public_ip       = true
    skip_source_dest_check = false

    nsg_ids = [
      oci_core_network_security_group.nsg.id
    ]
  }

  shape_config {
    ocpus         = 2
    memory_in_gbs = 12
  }

defined_tags = {
  "${data.oci_identity_tag_namespaces.devops.tag_namespaces[0].name}.${data.oci_identity_tags.access.tags[0].name}" = "vault"
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
    source_type             = "image"
    source_id               = "ocid1.image.oc1.iad.aaaaaaaawvs4xn6dfl6oo45o2ntziecjy2cbet2mlidvx3ji62oi3jai4u5a"
    boot_volume_size_in_gbs = 55
  }

  depends_on = [data.oci_identity_tags.access]
}

# === VNIC and Public IP ===
data "oci_core_vnic_attachments" "uat" {
  compartment_id = oci_identity_compartment.devops_portfolio.id
  instance_id    = oci_core_instance.uat.id
}

data "oci_core_vnic" "uat" {
  vnic_id    = data.oci_core_vnic_attachments.uat.vnic_attachments[0].vnic_id
  depends_on = [oci_core_instance.uat]
}

# === CLOUDFLARE DNS ===
resource "cloudflare_dns_record" "uat" {
  zone_id = var.cloudflare_zone_id
  name    = "uat"
  type    = "A"
  content = oci_core_instance.uat.public_ip
  ttl     = 300
  proxied = false

  depends_on = [oci_core_instance.uat]
}

resource "cloudflare_dns_record" "jenkins" {
  zone_id = var.cloudflare_zone_id
  name    = "jenkins"
  type    = "A"
  content = oci_core_instance.uat.public_ip
  ttl     = 300
  proxied = false

  depends_on = [oci_core_instance.uat]
}