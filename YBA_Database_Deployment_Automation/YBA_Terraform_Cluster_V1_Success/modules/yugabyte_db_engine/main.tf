###############################################
# Locals
###############################################
locals {
  external_ip_add     = var.enable_external_ip ? 1 : 0
  access_config       = local.external_ip_add != 0 ? [true] : []
  shielded_vm_configs = var.enable_shielded_vm ? [true] : []

  instance_name = [
    for i in range(1, var.instance_count + 1) :
    format("%s%d", var.machine_name, i)
  ]

  disk_name = [
    for idx, name in local.instance_name :
    [for i in range(1, var.attached_disks_per_instance + 1) :
      format("%s-persistent-disk%d", name, i)
    ]
  ]

  attached_disk_names = flatten(local.disk_name)

  instance = flatten([
    for idx, name in local.instance_name :
    [for i in range(1, var.attached_disks_per_instance + 1) : name]
  ])

  zones = flatten([
    for idx, zone in range(var.instance_count) :
    [for i in range(var.attached_disks_per_instance) :
      element(var.machine_zone, zone % length(var.machine_zone))
    ]
  ])
}

###############################################
# Snapshot Policy
###############################################
resource "google_compute_resource_policy" "snapshot_policy" {
  name = var.policy_name

  snapshot_schedule_policy {
    schedule {
      hourly_schedule {
        hours_in_cycle = 23
        start_time     = var.utc_time
      }
    }
    retention_policy {
      max_retention_days    = var.retention_days
      on_source_disk_delete = "KEEP_AUTO_SNAPSHOTS"
    }
    snapshot_properties {
      storage_locations = [var.storage_locations]
    }
  }
}

###############################################
# Boot Disk Creation
###############################################
resource "google_compute_disk" "boot_gce_disk" {
  count = var.enable_boot_disk ? var.instance_count : 0
  name  = "${var.machine_name}${count.index + 1}-boot-disk"
  size  = var.boot_disk_size
  type  = var.boot_disk_type
  zone  = element(var.machine_zone, count.index % length(var.machine_zone))

  snapshot = var.instance_with_bootdisk_snapshot ? var.snapshot_selflink : null
  image    = var.instance_with_bootdisk_snapshot ? null : var.instance_image_selflink

  disk_encryption_key {
    kms_key_self_link = var.kms_key_self_link
  }

  labels = merge(var.labels, {
    type     = "boot"
    resource = "disk"
  })

  physical_block_size_bytes = 4096

  #  LIFECYCLE PATCH
  lifecycle {
    ignore_changes = [
      image,
      snapshot,
      labels,
      disk_encryption_key,
      guest_os_features,
    ]
  }
}

###############################################
# Boot Disk Snapshot Policy Attachment
###############################################
resource "google_compute_disk_resource_policy_attachment" "boot_diskpolicy_attach" {
  count      = var.enable_boot_disk_snapshot_attach ? var.instance_count : 0
  name       = google_compute_resource_policy.snapshot_policy.name
  disk       = google_compute_disk.boot_gce_disk[count.index].name
  zone       = element(var.machine_zone, count.index % length(var.machine_zone))
  depends_on = [google_compute_disk.boot_gce_disk]
}

###############################################
# Random External IP Suffix
###############################################
resource "random_id" "external_ip_suffix" {
  count       = var.instance_count
  byte_length = 2
}

###############################################
# Static Internal IPs
###############################################
resource "google_compute_address" "static_internal_ip_address" {
  count        = var.instance_count
  name         = "${var.machine_name}-int-ip-${count.index + 1}"
  address_type = "INTERNAL"
  address      = element(var.internal_ip, count.index % length(var.internal_ip))
  subnetwork   = var.subnetwork
}

###############################################
# External IPs
###############################################
resource "google_compute_address" "static_external_ip_address" {
  count  = var.instance_count
  name   = "${var.machine_name}${count.index + 1}-ext-ip-${random_id.external_ip_suffix[count.index].hex}"
  region = var.region
}

###############################################
# VM Instance
###############################################
resource "google_compute_instance" "gce_vm" {
  count        = var.instance_count
  name         = local.instance_name[count.index]
  machine_type = var.machine_type
  zone         = element(var.machine_zone, count.index % length(var.machine_zone))

  allow_stopping_for_update = true
  deletion_protection       = var.vm_deletion_protection
  tags                      = var.network_tags

  boot_disk {
    auto_delete = true
    source      = google_compute_disk.boot_gce_disk[count.index].id
    device_name = google_compute_disk.boot_gce_disk[count.index].name
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    network_ip = google_compute_address.static_internal_ip_address[count.index].address

    dynamic "access_config" {
      for_each = local.access_config
      content {
        nat_ip       = google_compute_address.static_external_ip_address[count.index].address
        network_tier = "PREMIUM"
      }
    }
  }

  #  REPLACED LIFECYCLE BLOCK (expanded version)
  lifecycle {
    ignore_changes = [
      attached_disk,
      metadata,
      boot_disk[0].initialize_params,
      boot_disk[0].source,
      network_interface[0].stack_type,
      network_interface[0].subnetwork_project,
      service_account,
      shielded_instance_config,
      resource_policies,
    ]
  }

  labels = merge(var.labels, { resource = "gce_vm" })

  dynamic "service_account" {
    for_each = [var.service_account]
    content {
      email  = service_account.value.email
      scopes = service_account.value.scopes
    }
  }

  metadata = var.metadata

  dynamic "scratch_disk" {
    for_each = range(var.local_disk_count)
    content { interface = "NVME" }
  }

  dynamic "shielded_instance_config" {
    for_each = local.shielded_vm_configs
    content {
      enable_secure_boot          = var.shielded_instance_config.enable_secure_boot
      enable_vtpm                 = var.shielded_instance_config.enable_vtpm
      enable_integrity_monitoring = var.shielded_instance_config.enable_integrity_monitoring
    }
  }
}

###################################################################################################
# Persistent Disks: Yugabyte, Data1, Wal1, Shared
###################################################################################################

###############################################
# Yugabyte Disk
###############################################
resource "google_compute_disk" "yugabyte" {
  count = var.enable_yugabyte_disk ? var.instance_count : 0
  name  = "${var.machine_name}${count.index + 1}-yugabyte"
  size  = element(var.attached_persistent_disk_sizes, 0)
  type  = "pd-ssd"
  zone  = element(var.machine_zone, count.index % length(var.machine_zone))

  disk_encryption_key { kms_key_self_link = var.kms_key_self_link }
  labels = merge(var.labels, { type = "yugabyte", resource = "attached_disk" })

  #  LIFECYCLE PATCH
  lifecycle {
    ignore_changes = [
      image,
      snapshot,
      labels,
      disk_encryption_key,
      guest_os_features,
    ]
  }

}

resource "google_compute_attached_disk" "yugabyte_attach" {
  count    = var.enable_yugabyte_disk ? var.instance_count : 0
  disk     = google_compute_disk.yugabyte[count.index].name
  instance = google_compute_instance.gce_vm[count.index].id
  zone     = google_compute_disk.yugabyte[count.index].zone

  #  LIFECYCLE PATCH
  lifecycle {
    ignore_changes = [disk]
  }
}

resource "google_compute_disk_resource_policy_attachment" "yugabyte_snapshot_attach" {
  count = var.enable_yugabyte_disk_snapshot_attach ? var.instance_count : 0
  name  = google_compute_resource_policy.snapshot_policy.name
  disk  = google_compute_disk.yugabyte[count.index].name
  zone  = google_compute_disk.yugabyte[count.index].zone
}

###############################################
# Data1 Disk
###############################################
resource "google_compute_disk" "data1" {
  count = var.enable_data1_disk ? var.instance_count : 0
  name  = "${var.machine_name}${count.index + 1}-data1"
  size  = element(var.attached_persistent_disk_sizes, 1)
  type  = "pd-ssd"
  zone  = element(var.machine_zone, count.index % length(var.machine_zone))
  disk_encryption_key { kms_key_self_link = var.kms_key_self_link }
  labels = merge(var.labels, { type = "data1", resource = "attached_disk" })

  #  LIFECYCLE PATCH
  lifecycle {
    ignore_changes = [
      image,
      snapshot,
      labels,
      disk_encryption_key,
      guest_os_features,
    ]
  }

}

resource "google_compute_attached_disk" "data1_attach" {
  count    = var.enable_data1_disk ? var.instance_count : 0
  disk     = google_compute_disk.data1[count.index].name
  instance = google_compute_instance.gce_vm[count.index].id
  zone     = google_compute_disk.data1[count.index].zone

  #  LIFECYCLE PATCH
  lifecycle {
    ignore_changes = [disk]
  }
}

resource "google_compute_disk_resource_policy_attachment" "data1_snapshot_attach" {
  count = (var.enable_data1_disk && var.enable_data1_disk_snapshot_attach) ? var.instance_count : 0
  name  = google_compute_resource_policy.snapshot_policy.name
  disk  = google_compute_disk.data1[count.index].name
  zone  = google_compute_disk.data1[count.index]
}




###############################################
# Wal1 Disk
###############################################
resource "google_compute_disk" "wal1" {
  count = var.enable_wal1_disk ? var.instance_count : 0
  name  = "${var.machine_name}${count.index + 1}-wal1"
  size  = element(var.attached_persistent_disk_sizes, 2)
  type  = "pd-ssd"
  zone  = element(var.machine_zone, count.index % length(var.machine_zone))

  disk_encryption_key { kms_key_self_link = var.kms_key_self_link }
  labels = merge(var.labels, { type = "wal1", resource = "attached_disk" })

  lifecycle {
    ignore_changes = [
      image,
      snapshot,
      labels,
      disk_encryption_key,
      guest_os_features,
    ]
  }

}

resource "google_compute_attached_disk" "wal1_attach" {
  count    = var.enable_wal1_disk ? var.instance_count : 0
  disk     = google_compute_disk.wal1[count.index].name
  instance = google_compute_instance.gce_vm[count.index].id
  zone     = google_compute_disk.wal1[count.index].zone

  lifecycle {
    ignore_changes = [disk]
  }
}

resource "google_compute_disk_resource_policy_attachment" "wal1_snapshot_attach" {
  count = (var.enable_wal1_disk && var.enable_wal1_disk_snapshot_attach) ? var.instance_count : 0
  name  = google_compute_resource_policy.snapshot_policy.name
  disk  = google_compute_disk.wal1[count.index].name
  zone  = google_compute_disk.wal1[count.index].zone
}


###############################################
# Shared Disk
###############################################
resource "google_compute_disk" "shared" {
  count = var.enable_shared_disk ? var.instance_count : 0
  name  = "${var.machine_name}${count.index + 1}-shared"
  size  = element(var.attached_persistent_disk_sizes, 2)
  type  = "pd-ssd"
  zone  = element(var.machine_zone, count.index % length(var.machine_zone))

  disk_encryption_key { kms_key_self_link = var.kms_key_self_link }
  labels = merge(var.labels, { type = "shared", resource = "attached_disk" })

  lifecycle {
    ignore_changes = [
      image,
      snapshot,
      labels,
      disk_encryption_key,
      guest_os_features,
    ]
  }

}

resource "google_compute_attached_disk" "shared_attach" {
  count    = var.enable_shared_disk ? var.instance_count : 0
  disk     = google_compute_disk.shared[count.index].name
  instance = google_compute_instance.gce_vm[count.index].id
  zone     = google_compute_disk.shared[count.index].zone

  lifecycle {
    ignore_changes = [disk]
  }
}

resource "google_compute_disk_resource_policy_attachment" "shared_snapshot_attach" {
  count = (var.enable_shared_disk && var.enable_shared_disk_snapshot_attach) ? var.instance_count : 0
  name  = google_compute_resource_policy.snapshot_policy.name
  disk  = google_compute_disk.shared[count.index].name
  zone  = google_compute_disk.shared[count.index].zone
}

