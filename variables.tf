variable "apic_url" {}
variable "apic_username" {}
variable "apic_password" {}

#config variables

variable "tenant" {
    type    = string
    }
    
variable "app_profile" {
    type    = string
    }

variable "vrf_dict" {
    type    = map(string)
    }

variable "bd_dict" {
    type    = map(string)
    }
    
variable "subnets_dict" {
    type    = map(string)
    }

variable "epg_dict" {
    type    = map(string)
    }

variable "epg_vlans" {
    type    = map(string)
    }
