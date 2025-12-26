# google\_compute\_resource\_policy


Here is a **clean, complete, and beginner-friendly explanation** of **`google_compute_resource_policy`** in Terraform — with real-world examples, diagrams, and use cases.

---

# 🌟 **What is `google_compute_resource_policy`?**

`google_compute_resource_policy` is a **Terraform resource** used to create **scheduling and management policies** for Google Compute Engine (GCE) resources like:

* Persistent disks
* Compute Engine VMs
* Instance groups

It allows you to define **automated recurring operations**, such as:

### ✔ **Disk Snapshot Schedules**

Automatically take snapshots of your persistent disks daily/weekly.

### ✔ **VM Instance Schedules**

Automatically start or stop VMs at defined times.

### ✔ **Group placement policies**

Specify how instances are placed for high availability.

---

# 🔥 **Why is Resource Policy Needed?**

You use `google_compute_resource_policy` when you want automation in GCP compute environments.

Example situations:

* Automatically take snapshots every night at 1 AM
* Stop dev/test instances at 8 PM to reduce costs
* Start instances at 9 AM for working hours
* Manage HA placement for VM groups

---

# ✔ Types of `resource_policy` You Can Create

Google Compute Engine supports these major policies:


| Policy Type                  | Description                                               |
| ---------------------------- | --------------------------------------------------------- |
| **Snapshot Schedule Policy** | Defines when persistent disk snapshots should be created. |
| **Instance Schedule Policy** | Automatically starts/stops or suspends instances.         |
| **Group Placement Policy**   | Defines how VMs are distributed across zones/hosts.       |

---

# 🧩 **1. Snapshot Schedule Policy (Most Common)**

### Example: Take snapshot **daily at 01:00 AM**

```hcl
resource "google_compute_resource_policy" "daily_snapshot" {
  name        = "daily-snapshot-policy"
  region      = var.region

  snapshot_schedule_policy {
    schedule {
      daily_schedule {
        days_in_cycle = 1
        start_time    = "01:00"
      }
    }

    retention_policy {
      max_retention_days = 7
      on_source_disk_delete = "KEEP_AUTO_SNAPSHOTS"
    }

    snapshot_properties {
      labels = {
        created_by = "terraform"
      }
    }
  }
}
```

### Attach this policy to a disk:

```hcl
resource "google_compute_disk_resource_policy_attachment" "disk_attach" {
  disk         = google_compute_disk.my_disk.name
  region       = var.region
  resource_policy = google_compute_resource_policy.daily_snapshot.id
}
```

---

# 🧩 **2. VM Instance Schedule Policy (Start/Stop Automation)**

### Example:

* Start VM at **09:00 AM**
* Stop VM at **08:00 PM**

```hcl
resource "google_compute_resource_policy" "instance_schedule" {
  name   = "office-hours-policy"
  region = var.region

  instance_schedule_policy {
    vm_start_schedule {
      schedule = "0 9 * * *" # Every day at 9 AM
    }
    vm_stop_schedule {
      schedule = "0 20 * * *" # Every day at 8 PM
    }
    time_zone = "Asia/Kolkata"
  }
}
```

### Attach policy to the instance:

```hcl
resource "google_compute_instance" "my_vm" {
  name         = "test-vm"
  machine_type = "e2-medium"
  zone         = var.zone

  resource_policies = [
    google_compute_resource_policy.instance_schedule.id
  ]
}
```

---

# 🧩 **3. Group Placement Policy**

Used mostly for high availability in MIGs (Managed Instance Groups).

### Example: Spread instances across zones

```hcl
resource "google_compute_resource_policy" "group_placement" {
  name   = "spread-policy"
  region = var.region

  group_placement_policy {
    vm_count = 3
    availability_domain_count = 3
  }
}
```

Attach to MIG:

```hcl
resource "google_compute_region_instance_group_manager" "mig" {
  name = "my-mig"

  versions {
    instance_template = google_compute_instance_template.my_template.self_link
  }

  resource_policies = [
    google_compute_resource_policy.group_placement.id
  ]
}
```

---

# 🎯 **When to Use Each Policy?**


| Situation                 | Policy Type       |
| ------------------------- | ----------------- |
| Daily disk backups        | Snapshot schedule |
| Auto start/stop VMs       | Instance schedule |
| HA for multiple instances | Group placement   |
| Cost optimization         | Instance schedule |
| Backup compliance         | Snapshot schedule |

---

# 📘 **Advanced Concepts You Should Learn**

### ✔ How snapshot retention works

### ✔ Snapshot naming patterns

### ✔ Understanding CRON formats

### ✔ Resource policy attachment rules

### ✔ Regional vs Zonal policies

### ✔ Limitations (e.g., suspension not supported everywhere)

---

# 🎓 If You Want, I Can Create:

✅ Step-by-step lab setup
✅ Real-world use case with a full Terraform module
✅ Visual diagrams
✅ A practice exercise with tasks
✅ A full production-grade example

---

# Would you like:

### 🔹 Snapshot policy deep dive?

### 🔹 Instance schedule deep dive?

### 🔹 Both with real-world architecture diagrams?

Tell me, and I’ll prepare it fully!
