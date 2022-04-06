resource "aci_tenant" "test-tenant" {
  name        = "${var.tenant}"    
}

resource "aci_vrf" "test-vrf" {

  for_each = var.vrf_dict
  
  # CAN'T INTERPOLATE ON RESOURCE NAMES... SO LET'S USE THE DN LITERAL :)
  
  tenant_dn              = "uni/tn-${var.tenant}"
  name                   = each.key
  bd_enforced_enable     = "no"
  ip_data_plane_learning = "enabled"
  knw_mcast_act          = "permit"
  pc_enf_dir             = "ingress"
  pc_enf_pref            = "enforced"
}


resource "aci_bridge_domain" "terraform-BD" {

  for_each = var.bd_dict

  tenant_dn   = "uni/tn-${var.tenant}"
  name        = each.key
  
  # AS WE HAVE MULTIPLE INSTANCES OF THE SAME RESOURCE, INTERPOLATION OF THE FV_RS_CTX IS MESSY... SO LET'S USE THE DN LITERAL :)
  
  relation_fv_rs_ctx = "uni/tn-${var.tenant}/ctx-${each.value}"
  
  #APP-CENTRIC LIKE EXAMPLE W FLOOD IN ENCAPS: NO SPINE-PROXYING
  
  multi_dst_pkt_act = "encap-flood"
  unk_mac_ucast_act = "flood"
  unk_mcast_act = "flood"
  v6unk_mcast_act = "flood"
  arp_flood = "yes"
}


resource "aci_subnet" "demosubnet" {

  for_each = var.subnets_dict

  parent_dn                    = "uni/tn-${var.tenant}/BD-${each.key}"
  ip                           = each.value
  scope                        = ["public"]
  #relation_fv_rs_bd_subnet_to_out = [aci_l3_outside.rdelmont-TFL3Out.id]
}


/*
resource "aci_l3_outside" "rdelmont-TFL3Out" {
        tenant_dn      = aci_tenant.${var.tenant}.id
        name           = "rdelmont-TFL3Out"
        enforce_rtctrl = ["export", "import"]
        target_dscp    = "unspecified"
        relation_l3ext_rs_ectx = aci_vrf.rdelmont_terraform-VRF.id
}

resource "aci_external_network_instance_profile" "rdelmont-TF_ExtEPG" {
        l3_outside_dn  = aci_l3_outside.rdelmont-TFL3Out.id
        name           = "rdelmont-TF_ExtEPG"
        flood_on_encap = "disabled"
        match_t        = "All"
        pref_gr_memb   = "exclude"
        prio           = "unspecified"
        target_dscp    = "unspecified"
}

resource "aci_l3_ext_subnet" "foosubnet" {
      external_network_instance_profile_dn  = aci_external_network_instance_profile.rdelmont-TF_ExtEPG.id
      ip                                    = "10.0.0.0/8"
      aggregate                             = "none"
      annotation                            = "tag_ext_subnet"
      scope                                 = ["import-rtctrl","import-security"]
      relation_l3ext_rs_subnet_to_profile {
        tn_rtctrl_profile_dn  = aci_route_control_profile.bgp_route_control_profile.id
        direction = "import"
      }
}
*/
