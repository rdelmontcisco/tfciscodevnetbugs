apic_url = "XXXXXX"
apic_username = "XXXXXX"
apic_password = "XXXXXX"

# config variables

tenant = "rdelmont_terraform-TN"
vrf_dict = {"TF-VRF-1":""}
bd_dict = {"BD-1":"TF-VRF-1", "BD-2":"TF-VRF-1"}
subnets_dict = {"BD-1":"172.16.100.1/24", "BD-2":"172.16.200.1/24"}
app_profile = "test-APP"
epg_dict = {"WEB":"BD-1", "APP":"BD-2"}
epg_vlans = {"WEB":"vlan-2680", "APP":"vlan-2681"}
