variable "network_project_id" {
  description = "The project ID where the network resources are located"
  type        = string
}

##############################################################
# Root Module Variables
##############################################################

# GCP Project ID
variable "project_id" {
  description = "The GCP project ID where resources will be created."
  type        = string
}

# KMS Key Self Link
variable "kms_key_self_link" {
  description = "The full resource path of the KMS crypto key to encrypt disks (CMEK)"
  type        = string
  default     = null
}

# GCP Region
variable "region" {
  description = "Default region for GCP resources."
  type        = string
}

##############################################################
# Yugabyte Cluster Project 1 — FULL SCHEMA
##############################################################

variable "yugabyte_clusters_project1" {
  description = "Configuration For Yugabyte Cluster For Project-1"

  type = map(
    object({

      enable_external_ip          = bool
      enable_shielded_vm          = bool
      machine_name                = string
      instance_count              = number
      attached_disks_per_instance = number

      enable_yugabyte_disk = bool
      enable_data1_disk    = bool
      enable_shared_disk   = bool
      enable_wal1_disk     = bool

      # Snapshot attach flags (OPTIONAL)
      enable_boot_disk_snapshot_attach     = optional(bool, false)
      enable_yugabyte_disk_snapshot_attach = optional(bool, false)
      enable_data1_disk_snapshot_attach    = optional(bool, false)
      enable_wal1_disk_snapshot_attach     = optional(bool, false)
      enable_shared_disk_snapshot_attach   = optional(bool, false)

      attached_persistent_disk_sizes = list(number)
      machine_zone                   = list(string)
      policy_name                    = string
      utc_time                       = string
      retention_days                 = number
      storage_locations              = string

      enable_boot_disk                = bool
      boot_disk_size                  = number
      boot_disk_type                  = string
      instance_with_bootdisk_snapshot = bool
      snapshot_selflink               = string
      instance_image_selflink         = string
      kms_key_self_link               = string

      labels                 = map(string)
      internal_ip            = list(string)
      region                 = string
      machine_type           = string
      vm_deletion_protection = bool
      network_tags           = list(string)
      network                = string
      subnetwork             = string

      service_account = object({
        email  = string
        scopes = list(string)
      })

      metadata         = map(string)
      local_disk_count = number

      shielded_instance_config = object({
        enable_secure_boot          = bool
        enable_vtpm                 = bool
        enable_integrity_monitoring = bool
      })
    })
  )
}
