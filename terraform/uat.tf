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

  shape_config {
    ocpus         = 2
    memory_in_gbs = 12
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
    source_type               = "image"
    source_id                 = "ocid1.image.oc1.iad.aaaaaaaawvs4xn6dfl6oo45o2ntziecjy2cbet2mlidvx3ji62oi3jai4u5a"
    boot_volume_size_in_gbs   = 55
  }
}

# === VNIC CREATION WITH NSG ATTACHED ===
resource "oci_core_vnic_attachment" "uat_vnic_attachment" {
  instance_id = oci_core_instance.uat.id

  create_vnic_details {
    subnet_id              = oci_core_subnet.uat_subnet.id
    display_name           = "uat-vnic"
    assign_public_ip       = true
    nsg_ids                = [oci_core_network_security_group.nsg.id]
    skip_source_dest_check = false
  }
}

# === VNIC DATA SOURCE ===
data "oci_core_vnic" "uat" {
  vnic_id = oci_core_vnic_attachment.uat_vnic_attachment.vnic_id
}

# === CLOUDFLARE DNS RECORD FOR UAT ===
resource "cloudflare_dns_record" "uat" {
  zone_id = var.cloudflare_zone_id
  name    = "uat"
  type    = "A"
  content = data.oci_core_vnic.uat.public_ip_address
  ttl     = 300
  proxied = false
}

# === CLOUDFLARE DNS RECORD FOR JENKINS ===
resource "cloudflare_dns_record" "jenkins" {
  zone_id = var.cloudflare_zone_id
  name    = "jenkins"
  type    = "A"
  content = data.oci_core_vnic.uat.public_ip_address
  ttl     = 300
  proxied = false
}