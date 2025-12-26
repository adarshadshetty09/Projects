###########################################
# Root Module: Yugabyte Cluster Deployment
###########################################

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0.0"
    }
  }
}

###########################################
# Yugabyte Cluster Module Invocation
###########################################

module "yugabyte-cluster-project-1" {
  for_each   = var.yugabyte_clusters_project1
  project_id = var.project_id
  source     = "./modules/yugabyte_db_engine"

  # Core configuration
  enable_external_ip             = each.value.enable_external_ip
  enable_shielded_vm             = each.value.enable_shielded_vm
  machine_name                   = each.value.machine_name
  instance_count                 = each.value.instance_count
  attached_disks_per_instance    = each.value.attached_disks_per_instance
  attached_persistent_disk_sizes = each.value.attached_persistent_disk_sizes
  machine_zone                   = each.value.machine_zone

  # Snapshot policy
  policy_name       = each.value.policy_name
  utc_time          = each.value.utc_time
  retention_days    = each.value.retention_days
  storage_locations = each.value.storage_locations

  # Boot disk
  enable_boot_disk = each.value.enable_boot_disk
  boot_disk_size   = each.value.boot_disk_size
  boot_disk_type   = each.value.boot_disk_type

  #################################

  enable_yugabyte_disk = each.value.enable_yugabyte_disk
  enable_data1_disk    = each.value.enable_data1_disk
  enable_wal1_disk     = each.value.enable_wal1_disk
  enable_shared_disk   = each.value.enable_shared_disk

  ##################################################
  instance_with_bootdisk_snapshot = each.value.instance_with_bootdisk_snapshot
  snapshot_selflink               = each.value.snapshot_selflink
  instance_image_selflink         = each.value.instance_image_selflink

  # KMS + Labels
  kms_key_self_link = each.value.kms_key_self_link
  labels            = each.value.labels

  # Network
  internal_ip            = each.value.internal_ip
  region                 = each.value.region
  machine_type           = each.value.machine_type
  vm_deletion_protection = each.value.vm_deletion_protection
  network_tags           = each.value.network_tags
  network                = each.value.network
  subnetwork             = each.value.subnetwork

  # Service Account + Metadata
  service_account = each.value.service_account
  metadata        = each.value.metadata

  # Shielded VM and Local disks
  local_disk_count         = each.value.local_disk_count
  shielded_instance_config = each.value.shielded_instance_config

  # In your main.tf file for both module blocks:

  # Snapshot policy attachment control
  enable_boot_disk_snapshot_attach     = each.value.enable_boot_disk_snapshot_attach
  enable_yugabyte_disk_snapshot_attach = each.value.enable_yugabyte_disk_snapshot_attach
  enable_data1_disk_snapshot_attach    = each.value.enable_data1_disk_snapshot_attach
  enable_wal1_disk_snapshot_attach     = each.value.enable_wal1_disk_snapshot_attach
  enable_shared_disk_snapshot_attach   = each.value.enable_shared_disk_snapshot_attach

}
