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

# Yugabyte Cluster Definitions
variable "yugabyte_clusters" {
  description = "Configuration for yugabyte DB nodes"
}


