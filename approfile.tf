resource "aci_application_profile" "test-app" {
  tenant_dn = "uni/tn-${var.tenant}"
  name       = "${var.app_profile}"
}

resource "aci_application_epg" "test-epg" {

    for_each = var.epg_dict
    
    application_profile_dn  = "uni/tn-${var.tenant}/ap-${var.app_profile}"
    name                    = each.key
    flood_on_encap          = "disabled"
    fwd_ctrl                = "none"
    has_mcast_source        = "no"
    match_t                 = "AtleastOne"
    pc_enf_pref             = "unenforced"
    pref_gr_memb            = "exclude"
    prio                    = "unspecified"
    shutdown                = "no"
    
    # AS WE HAVE MULTIPLE INSTANCES OF THE SAME RESOURCE, INTERPOLATION OF THE FV_RS_BD IS MESSY... SO LET'S USE THE DN LITERAL :)
    
    relation_fv_rs_bd       = "uni/tn-${var.tenant}/BD-${each.value}"
    #relation_fv_rs_cons     = [aci_contract.rdelmont-TFcontract.id]
  }
  
resource "aci_epg_to_domain" "test-epg-tdn" {

  for_each = var.epg_dict
    
  application_epg_dn    = "uni/tn-${var.tenant}/ap-${var.app_profile}/epg-${each.key}"
  tdn                   = "uni/phys-rdelmont_PhyDom"
  }

resource "aci_epg_to_static_path" "test-epg-encaps" {

  for_each = var.epg_vlans
    
  application_epg_dn  = "uni/tn-${var.tenant}/ap-${var.app_profile}/epg-${each.key}"
  tdn  = "topology/pod-1/protpaths-201-202/pathep-[Shared-vPC-N5K1-2_IPG]"
  encap  = each.value
}

  
/*

resource "aci_filter_entry" "rdelmont-TFfe_TCP" {
        filter_dn     = aci_filter.rdelmont-TFfilter_TCP.id
        name          = "rdelmont-TFfilter_TCP"
        apply_to_frag = "no"
        d_from_port   = "443"
        d_to_port     = "443"
        ether_t       = "ipv4"
        prot          = "tcp"
        s_from_port   = "unspecified"
        s_to_port     = "unspecified"
        stateful      = "no"
}

resource "aci_filter_entry" "rdelmont-TFfe_ICMP" {
        filter_dn     = aci_filter.rdelmont-TFfilter_ICMP.id
        name          = "rdelmont-TFfilter_ICMP"
        ether_t       = "ipv4"
        prot          = "icmp"
}

# PUTTING BI-DIRECTIONAL RELATIONSHIP W CONTRACT WILL ENABLE "APPLY BOTH DIRECTION"

resource "aci_filter" "rdelmont-TFfilter_ICMP" {
        tenant_dn   = aci_tenant.${var.tenant}.id
        name        = "rdelmont-TFfilter_ICMP"
        relation_vz_rs_fwd_r_flt_p_att = aci_contract.rdelmont-TFcontract.id
        relation_vz_rs_rev_r_flt_p_att = aci_contract.rdelmont-TFcontract.id
}

resource "aci_filter" "rdelmont-TFfilter_TCP" {
        tenant_dn   = aci_tenant.${var.tenant}.id
        name        = "rdelmont-TFfilter_TCP"
        relation_vz_rs_rev_r_flt_p_att = aci_contract.rdelmont-TFcontract.id
}

resource "aci_contract_subject" "rdelmont-TFsbj" {
        contract_dn   = aci_contract.rdelmont-TFcontract.id
        name          = "rdelmont-TFsbj"
        cons_match_t  = "AtleastOne"
        prio          = "unspecified"
        prov_match_t  = "AtleastOne"
        rev_flt_ports = "yes"
        target_dscp   = "unspecified"
        relation_vz_rs_subj_filt_att = [aci_filter.rdelmont-TFfilter_ICMP.id, aci_filter.rdelmont-TFfilter_TCP.id]
}

resource "aci_contract" "rdelmont-TFcontract" {
        tenant_dn   =  aci_tenant.${var.tenant}.id
        name        = "rdelmont-TFcontract"
        prio        = "unspecified"
        scope       = "tenant"
        target_dscp = "unspecified"
}
*/
