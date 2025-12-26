######################################################################
# Core Configuration
######################################################################

variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "Region where resources will be deployed"
  type        = string
}

variable "machine_zone" {
  description = "Zone(s) where the instance(s) will be created"
  type        = list(string)
}

variable "machine_name" {
  description = "Base name for VM instances"
  type        = string
}

variable "instance_count" {
  description = "Number of VM instances to create"
  type        = number
  default     = 3
}

######################################################################
# Networking
######################################################################

variable "network" {
  description = "The self-link or name of the network to attach the VM to"
  type        = string
}

variable "subnetwork" {
  description = "The subnetwork self-link or name to attach the VM to"
  type        = string
}

variable "internal_ip" {
  description = "List of static internal IPs to assign to each instance"
  type        = list(string)
}

variable "enable_external_ip" {
  description = "Whether to assign an external IP to instances"
  type        = bool
  default     = true
}

######################################################################
# Instance & Compute Configuration
######################################################################

variable "machine_type" {
  description = "Machine type for the instance (e.g. e2-medium, n1-standard-1)"
  type        = string
}

variable "vm_deletion_protection" {
  description = "Enable deletion protection on the VM"
  type        = bool
  default     = false
}

variable "network_tags" {
  description = "Network tags applied to VMs for firewall rules"
  type        = list(string)
  default     = []
}

variable "metadata" {
  description = "Metadata key-value pairs for VM instances (e.g. startup scripts)"
  type        = map(string)
  default     = {}
}

variable "service_account" {
  description = "Service account configuration for VMs"
  type = object({
    email  = string
    scopes = list(string)
  })
  default = {
    email  = null
    scopes = []
  }
}

######################################################################
# Boot Disk Configuration
######################################################################

variable "enable_boot_disk" {
  description = "Enable creation of boot disks"
  type        = bool
  default     = true
}

variable "log_disk_size" {
  description = "Size (GB) of the boot disk"
  type        = number
  default     = null
}

variable "log_disk_type" {
  description = "Type of boot disk (e.g. pd-ssd, pd-standard, pd-balanced)"
  type        = string
  default     = "pd-ssd"
}

variable "instance_with_bootdisk_snapshot" {
  description = "If true, create boot disk from snapshot; else from image"
  type        = bool
  default     = true
}

variable "snapshot_selflink" {
  description = "Self-link of snapshot for boot disk creation"
  type        = string
  default     = null
}

variable "instance_image_selflink" {
  description = "Self-link of image used for boot disk creation"
  type        = string
  default     = null
}

######################################################################
# Persistent Attached Disk Configuration (Yugabyte, Data1, Wal1, Shared)
######################################################################

variable "enable_attached_persistant_disk" {
  description = "Enable creation and attachment of persistent data disks"
  type        = bool
  default     = true
}

variable "attached_disks_per_instance" {
  description = "Number of attached persistent disks per instance"
  type        = number
  default     = null
}

variable "attached_persistent_disk_sizes" {
  description = "List of disk sizes (GB) for attached disks"
  type        = list(number)
  # default     = [100, 200, 100, 50] # Yugabyte=100GB, Data1=200GB, Wal1=100GB, Shared=50GB
}

variable "data_disk_with_snapshot" {
  description = "Whether to create attached disks from existing snapshots"
  type        = bool
  default     = false
}

variable "data_disk_snapshot_selflink" {
  description = "Self-link of the snapshot for attached data disks"
  type        = string
  default     = null
}

######################################################################
# Log Disk Configuration (optional)
######################################################################

variable "enable_log_disk" {
  description = "Enable creation and attachment of log disks"
  type        = bool
  default     = false
}

variable "boot_disk_size" {
  description = "Size (GB) for log disk"
  type        = number
  default     = null
}

variable "boot_disk_type" {
  description = "Type of log disk (e.g., pd-ssd)"
  type        = string
  default     = "pd-ssd"
}

######################################################################
# Shielded VM and Local Disks
######################################################################

variable "enable_shielded_vm" {
  description = "Whether to enable Shielded VM configuration"
  type        = bool
  default     = true
}

variable "shielded_instance_config" {
  description = "Shielded VM configuration options"
  type = object({
    enable_secure_boot          = bool
    enable_vtpm                 = bool
    enable_integrity_monitoring = bool
  })
  default = {
    enable_secure_boot          = false
    enable_vtpm                 = false
    enable_integrity_monitoring = false
  }
}

variable "local_disk_count" {
  description = "Number of local scratch disks (NVME)"
  type        = number
  default     = 0
}

######################################################################
# KMS Encryption and Labels
######################################################################

variable "kms_key_self_link" {
  description = "KMS encryption key self-link used for all disks"
  type        = string
}

variable "labels" {
  description = "Labels applied to all resources"
  type        = map(string)
  default     = {}
}

######################################################################
# Snapshot Policy Configuration
######################################################################

variable "policy_name" {
  description = "Name for the snapshot policy"
  type        = string
}

variable "utc_time" {
  description = "Start time for snapshot schedule (UTC format, e.g. 03:00)"
  type        = string
}

variable "retention_days" {
  description = "Number of days to retain snapshots"
  type        = number
  default     = 7
}

variable "storage_locations" {
  description = "Region or multi-region for storing snapshots (e.g. us, europe, asia)"
  type        = string
}

##################################################################################################################

variable "enable_yugabyte_disk" {
  description = "Enable Yugabyte disk creation & attachment"
  type        = bool
  default     = false
}

variable "enable_data1_disk" {
  description = "Enable Data1 disk creation & attachment"
  type        = bool
  default     = false
}

variable "enable_wal1_disk" {
  description = "Enable Wal1 disk creation & attachment"
  type        = bool
  default     = false
}

variable "enable_shared_disk" {
  description = "Enable Shared disk creation & attachment"
  type        = bool
  default     = false
}


# Add these new variables to the module's variables.tf file

variable "enable_boot_disk_snapshot_attach" {
  description = "Controls whether the snapshot policy is attached to the boot disk."
  type        = bool
  default     = false
}

variable "enable_yugabyte_disk_snapshot_attach" {
  description = "Controls whether the snapshot policy is attached to the yugabyte disk."
  type        = bool
  default     = false
}

variable "enable_data1_disk_snapshot_attach" {
  description = "Controls whether the snapshot policy is attached to the data1 disk."
  type        = bool
  default     = false
}

variable "enable_wal1_disk_snapshot_attach" {
  description = "Controls whether the snapshot policy is attached to the wal1 disk."
  type        = bool
  default     = false
}

variable "enable_shared_disk_snapshot_attach" {
  description = "Controls whether the snapshot policy is attached to the shared disk."
  type        = bool
  default     = false
}