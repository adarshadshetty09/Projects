packer {
  required_plugins {
    googlecompute = {
      source  = "github.com/hashicorp/googlecompute"
      version = "~> 1"
    }
  }
}
 
source "googlecompute" "yba-gcp" {
  project_id              = "apt-index-474313-e9"
  region                  = "us-central1"
  zone                    = "us-central1-a"
  omit_external_ip        = false
  use_internal_ip         = false
  tags                    = ["yba-gcp-image-2"]
  ssh_username            = "yugabyte"
  machine_type            = "e2-standard-4"
  source_image_family     = "rhel-9"
  source_image_project_id = ["rhel-cloud"] # ← FIXED HERE
  image_name              = "yba-gcp-db-{{timestamp}}"
  image_family            = "yba-gcp-image"
  disk_size               = 20
  disk_type               = "pd-ssd"
}

 
 
 
build {
  sources = ["source.googlecompute.yba-gcp"]
 
  provisioner "shell" {
    inline = [
      "sudo yum install -y wget curl tar"
    ]
  }
 
  provisioner "ansible" {
    playbook_file   = "./yba_2024_db_node.yaml"
    use_proxy       = false
  }
}
