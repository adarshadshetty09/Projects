---
# ✅ **Full Roadmap to Learn OS-Level Linux (RHEL)**

Here is the complete sequence we will follow.
Tell me where you want to start — or I will start from **Basics → Advanced** automatically.
---
# 🔵 **1. Introduction to Linux OS**

### Concepts you’ll learn:

* What is an OS?
* Linux directory structure
* Important files in `/etc`, `/var`, `/usr`, `/proc`, `/sys`
* RHEL vs CentOS vs Fedora

---

# 🔵 **2. Core Linux Commands (Must Know)**

### Topics:

* File/Directory commands (`ls`, `cd`, `pwd`, `find`, `cp`, `mv`, `rm`)
* User & Access commands (`whoami`, `id`, `groups`)
* Viewing files (`cat`, `less`, `more`, `head`, `tail`)
* Editing files with **vim**

---

# 🔵 **3. User & Group Management**

### You will learn:

* How to **list all users**
* How to **list all groups**
* `/etc/passwd`, `/etc/shadow`, `/etc/group`
* `useradd`, `passwd`, `usermod`, `groupadd`
* sudo privileges → `/etc/sudoers`

---

# 🔵 **4. File Permissions & Ownership**

### Concepts:

* rwx permissions model
* `chmod`, `chown`, `chgrp`
* Special permissions:
  * SUID
  * SGID
  * Sticky bit
* SELinux basics (RHEL-specific)

---

# 🔵 **5. Boot Process (RHEL)**

### Learn:

* BIOS → GRUB → Kernel → systemd
* GRUB configuration
* systemd targets (runlevels)

---

# 🔵 **6. systemd Services (Most Important for DevOps)**

### You will learn:

* How to manage services:
  ```
  systemctl start/stop/enable/status
  ```
* How to read logs:
  ```
  journalctl -u <service>
  ```
* How to create your own service file.

---

# 🔵 **7. Networking**

### Topics:

* ip commands:
  ```
  ip addr
  ip route
  ip link
  ```
* DNS → `/etc/resolv.conf`
* Hostname → `hostnamectl`
* Firewall (`firewalld`)
* SELinux networking

---

# 🔵 **8. Storage & Filesystems**

### Very Important for your NFS and Disk work

You will learn:

* List disks → `lsblk`
* Partition → `fdisk`, `gdisk`
* Format → `mkfs.ext4`, `xfs`
* Mounting disks → `/etc/fstab`
* LVM: PV, VG, LV
* NFS basics:
  * Server (exports)
  * Client (mounting)
* Auto-mounting
* RAID concepts

---

# 🔵 **9. Process & Memory Management**

### Commands:

* `top`, `htop`, `ps`
* system load
* kill process
* Resource monitoring

---

# 🔵 **10. Logs & Troubleshooting**

### Learn:

* `/var/log/*`
* `journalctl`
* Reading kernel messages → `dmesg`
* Debugging service failures

---

# 🔵 **11. Security (RHEL specific)**

### Topics:

* SELinux (modes & contexts)
* FirewallD
* SSH security
* Fail2Ban

---

# 🔵 **12. Package Management**

### RHEL Package Tools:

* `yum`
* `dnf`
* Repositories
* Installing RPMs

---

# 🔵 **13. Kernel & Modules**

* `uname -r`
* Listing modules
* Loading/unloading modules
* sysctl tunables

---

# 🔵 **14. System Monitoring & Performance**

* CPU, memory, IO
* Tools: `sar`, `vmstat`, `iostat`, `free`

---

# 🔵 **15. Virtualization & Containers (Optional)**

* Podman (in RHEL)
* KVM & libvirt basics

---

Great!
We will start from **Option 1 → Basic Linux Commands (from ZERO)** on **RHEL 9.7**.

I will teach you **step-by-step**, with **real commands**, **explanations**, and **practical tasks** you can run on your server.

---

# 🚀 **Step 1: Basic Linux Navigation & File Commands**

These are the foundation of EVERYTHING in Linux.

---

# ✅ **1. Check where you are**

```
pwd
```

Shows your current directory.

Try it now and see output like:

```
/home/kaboonyugabyte
```

---

# ✅ **2. List files**

```
ls
```

Common options:

```
ls -l     # long list (permissions, owner, size)
ls -a     # show hidden files
ls -lh    # human readable (KB, MB)
```

---

# ✅ **3. Move inside a directory**

```
cd /etc
cd /var/log
cd ~              # to home directory
cd ..             # one step back
```

---

# ✅ **4. Create directories**

```
mkdir test
mkdir -p dir1/dir2/dir3   # create nested folders
```

---

# ✅ **5. Create empty files**

```
touch file1
touch file2 file3
```

---

# ✅ **6. View files**

```
cat file1              # show full file
less file1             # open page-by-page (q to exit)
head file1             # show first 10 lines
tail file1             # show last 10 lines
tail -f file1          # follow live updates
```

---

# ✅ **7. Copy files**

```
cp file1 file1_backup
cp -r dir1 dir1_backup     # copy directories
```

---

# ✅ **8. Move/Rename files**

```
mv file1 newname.txt
mv file1 /tmp/            # move to another folder
```

---

# ✅ **9. Delete files**

⚠️ Important: rm is permanent.

```
rm file1
rm -r dir1       # delete directory
rm -rf dir1      # force deletion (be careful!)
```

---

# ✅ **10. Searching files**

### Find by name:

```
find / -name "file1"
find /var/log -name "*.log"
```

### Search text inside files:

```
grep "yugabyte" file1
grep -r "error" /var/log
```

---

# 🚀 PRACTICAL TASK (Do this now)

Run these commands one-by-one to build muscle memory:

```
mkdir linux_practice
cd linux_practice

touch a b c
mkdir test1 test2

cp a test1/
mv b test2/b_new

echo "Hello Linux" > a
cat a

grep "Hello" a

ls -l
pwd
```

After you run these, tell me **“Done”** and I’ll take you to **Step 2: Important System Commands (whoami, id, groups, date, hostname, uptime, etc.)**

This will build your Linux foundation properly.

Great! Let’s move to **Step 2 – Important System Commands**.
These commands help you understand **system identity, users, groups, system time, uptime, hostname, and basic system details**.

Run each command on your RHEL server to see real output.

---

# 🚀 **STEP 2: Important System Commands**

---

# ✅ **1. Who am I?**

Shows which user is currently logged in.

```
whoami
```

Example output:

```
kaboonyugabyte
```

---

# ✅ **2. User identity details**

Shows **UID, GID, and groups** of the current user.

```
id
```

Example:

```
uid=1000(kaboonyugabyte) gid=1000(kaboonyugabyte) groups=1000(kaboonyugabyte),10(wheel)
```

---

# ✅ **3. List groups**

Shows all groups in your system.

```
getent group
```

or

```
cat /etc/group
```

---

# ✅ **4. List users**

Shows all OS users:

```
cat /etc/passwd
```

---

# ✅ **5. Check system date & time**

```
date
```

Change timezone if needed:

```
timedatectl
timedatectl set-timezone Asia/Kolkata
```

---

# ✅ **6. Check hostname**

```
hostname
hostnamectl
```

Change hostname:

```
sudo hostnamectl set-hostname NEWNAME
```

---

# ✅ **7. Check system uptime (how long system is up)**

```
uptime
```

Shows:

* uptime
* load average
* logged-in users

Example:

```
 18:22:11 up  3 days,  2:15,  1 user,  load average: 0.03, 0.04, 0.05
```

---

# ✅ **8. Check system information**

### Kernel version:

```
uname -r
```

### Full OS details:

```
cat /etc/os-release
```

### CPU details:

```
lscpu
```

### Memory info:

```
free -h
```

### Disk info:

```
lsblk
```

---

# ✅ **9. Logged-in users**

```
who
w
```

---

# ✅ **10. System logs overview**

List most logs:

```
ls /var/log
```

View system log:

```
journalctl -xe
```

---

# 🚀 **PRACTICAL ASSIGNMENT (Do This Now)**

Run the following commands on your server:

```
whoami
id
cat /etc/passwd
cat /etc/group
hostname
uname -r
free -h
df -h
uptime
lscpu
lsblk
timedatectl
```

Great! Since you’ve completed Step 2, let’s move to one of the most important OS-level topics:

# 🚀 **STEP 3 — User & Group Management (RHEL 9.7)**

This is a core skill for Linux administration, DevOps, and RHCSA.

We will cover:

### ✔ Listing users & groups

### ✔ Creating/deleting users

### ✔ Creating/deleting groups

### ✔ Adding users to groups

### ✔ Password management

### ✔ Understanding `/etc/passwd`, `/etc/shadow`, `/etc/group`

### ✔ Sudo access (very important)

Let’s go step-by-step.

---

# 🔵 **1. List All Users**

Users are stored in:

```
cat /etc/passwd
```

Each line = 1 user.

Format:

```
username:x:UID:GID:comment:home_directory:shell
```

Example:

```
root:x:0:0:root:/root:/bin/bash
```

---

# 🔵 **2. List All Groups**

Groups stored in:

```
cat /etc/group
```

---

# 🔵 **3. Add a New User**

```
sudo useradd devuser
```

Create home directory + default shell.

---

# 🔵 **4. Set Password**

```
sudo passwd devuser
```

It will ask:

```
Enter new password:
Retype new password:
```

---

# 🔵 **5. Add User to a Group**

Example: add user to **wheel** group (wheel = sudo group in RHEL)

```
sudo usermod -aG wheel devuser
```

Verify:

```
id devuser
```

---

# 🔵 **6. Create a Group**

```
sudo groupadd developers
```

Add user to that group:

```
sudo usermod -aG developers devuser
```

---

# 🔵 **7. Delete User**

Without deleting home:

```
sudo userdel devuser
```

Delete user + home:

```
sudo userdel -r devuser
```

---

# 🔵 **8. Delete Group**

```
sudo groupdel developers
```

---

# 🔵 **9. Check Logged-In Users**

```
who
w
```

---

# 🔵 **10. Give Sudo Access to Any User**

Two ways:

### **Method 1: Add to wheel group**

```
sudo usermod -aG wheel devuser
```

This is the recommended method on RHEL.

### **Method 2: Edit sudoers file** (Advanced)

```
sudo visudo
```

Add:

```
devuser ALL=(ALL) NOPASSWD:ALL
```

⚠ Use this only if you know what you're doing.

---

# 🔵 **11. Understanding `/etc/shadow`**

Passwords are stored in hashed form:

```
sudo cat /etc/shadow
```

Example:

```
devuser:$6$jf8f...$kx73...:19534:0:99999:7:::
```

You CANNOT decode this because it’s encrypted.

---

# 🚀 PRACTICAL TASK (Very Important)

Run these commands on your system:

```
sudo useradd testuser
sudo passwd testuser

sudo groupadd testgroup
sudo usermod -aG testgroup testuser

id testuser
cat /etc/passwd | grep testuser
cat /etc/group | grep testgroup

sudo usermod -aG wheel testuser       # give sudo access
```

Then test sudo:

```
su - testuser
sudo ls /root
```

If you see:

```
[sudo] password for testuser:
```

→ It is working.

Great — moving to the **MOST IMPORTANT OS-level Linux concept**:

# 🚀 **STEP 4 — File Permissions & Ownership (rwx, chmod, chown, sticky bit, SUID, SGID)**

This is the heart of Linux security + system administration.
Master this, and your Linux skills jump to the next level.

---

# 🔵 **1. Understanding rwx Permissions**

Every file/directory in Linux has 3 permission sets:


| Owner | Group | Others |
| ----- | ----- | ------ |
| rwx   | rwx   | rwx    |

Example:

```
-rw-r--r-- 1 root root  4096 Jan 20 file1
```

Breakdown:


| Field | Meaning                              |
| ----- | ------------------------------------ |
| `-`   | file type (`-`= file,`d`= directory) |
| `rw-` | owner permissions                    |
| `r--` | group permissions                    |
| `r--` | others permissions                   |

---

# 🔵 **2. What rwx Means**

### For files:

* **r** = read
* **w** = write
* **x** = execute (run program/script)

### For directories:

* **r** = list directory (`ls`)
* **w** = create/delete files
* **x** = enter directory (`cd`)

---

# 🔵 **3. View Permissions**

```
ls -l
```

---

# 🔵 **4. Changing Permissions (chmod)**

### A) Symbolic mode:

```
chmod u+r file1     # add read for owner
chmod g-w file1     # remove write for group
chmod o+x file1     # add execute for others
chmod u=rwx,g=rx,o= file1
```

### B) Numeric mode:

Each permission has a value:


| r | w | x |
| - | - | - |
| 4 | 2 | 1 |

Examples:

* `7 = rwx`
* `6 = rw-`
* `5 = r-x`
* `4 = r--`

Set permissions:

```
chmod 755 file1
chmod 644 file1
chmod 700 file1
```

---

# 🔵 **5. File Ownership (chown & chgrp)**

### Change owner:

```
sudo chown user1 file1
```

### Change group:

```
sudo chgrp developers file1
```

### Change both:

```
sudo chown user1:developers file1
```

---

# 🔵 **6. Special Permissions (Advanced but Important)**

## 🔶 **1. SUID (Set User ID)**

If set on a file → it runs with **owner privileges**.

Example:

```
chmod u+s file1
```

Permission looks like:

```
rwsr-xr-x
```

Used for commands like `passwd`.

---

## 🔶 **2. SGID (Set Group ID)**

If set on directory → new files inherit group.

```
chmod g+s dir1
```

Looks like:

```
rwxr-sr-x
```

Used for shared directories.

---

## 🔶 **3. Sticky Bit (Very Important for /tmp)**

Only the owner can delete files inside the directory.

```
chmod +t dir1
```

Looks like:

```
rwxrwxrwt
```

Common on `/tmp`:

```
drwxrwxrwt   10 root root   4096 /tmp
```

---

# 🔵 **7. PRACTICAL TASK (Do this now)**

Run this step-by-step:

```
mkdir perm_test
cd perm_test

touch file1
ls -l

chmod 644 file1
chmod 755 file1
chmod 700 file1

sudo useradd userA
sudo groupadd devgroup

sudo chown userA file1
sudo chown userA:devgroup file1

mkdir shared
chmod g+s shared

mkdir secure
chmod +t secure
```

Then verify:

```
ls -ld shared secure
```

Great — now we move to **one of the most important topics in real-world Linux & DevOps work**:

# 🚀 **STEP 5 — systemd Services (service management in RHEL 9.7)**

RHEL uses **systemd** to manage all services (NFS, MySQL, Docker, networking, etc.).
You must master this for any production environment.

---

# 🔵 **1. Check service status**

```
systemctl status <service>
```

Example:

```
systemctl status firewalld
systemctl status sshd
```

---

# 🔵 **2. Start / Stop / Restart a service**

```
sudo systemctl start <service>
sudo systemctl stop <service>
sudo systemctl restart <service>
```

Examples:

```
sudo systemctl restart sshd
sudo systemctl stop firewalld
```

---

# 🔵 **3. Enable service at boot**

```
sudo systemctl enable <service>
```

Disable:

```
sudo systemctl disable <service>
```

Check if enabled:

```
systemctl is-enabled <service>
```

---

# 🔵 **4. View logs of a service**

This is extremely important:

```
journalctl -u <service>
```

To see recent logs:

```
journalctl -u <service> -xe
```

Follow logs live:

```
journalctl -u <service> -f
```

---

# 🔵 **5. List all running services**

```
systemctl list-units --type=service
```

List all (running/non-running):

```
systemctl list-unit-files --type=service
```

---

# 🔵 **6. Check system boot target (runlevel equivalent)**

```
systemctl get-default
```

Change boot target:

```
sudo systemctl set-default multi-user.target
sudo systemctl set-default graphical.target
```

---

# 🔵 **7. Create Your Own systemd Service (Important!)**

Example: Run a script as a service.

### **Step 1: Create a script**

```
sudo mkdir /opt/myapp
echo '#!/bin/bash' | sudo tee /opt/myapp/start.sh
echo 'while true; do echo "Hello from service"; sleep 5; done' | sudo tee -a /opt/myapp/start.sh
sudo chmod +x /opt/myapp/start.sh
```

### **Step 2: Create a systemd service file**

```
sudo vi /etc/systemd/system/myapp.service
```

Paste:

```
[Unit]
Description=My Custom App Service

[Service]
ExecStart=/opt/myapp/start.sh
Restart=always

[Install]
WantedBy=multi-user.target
```

### **Step 3: Reload systemd**

```
sudo systemctl daemon-reload
```

### **Step 4: Start + Enable**

```
sudo systemctl start myapp
sudo systemctl enable myapp
```

### **Step 5: Check logs**

```
journalctl -u myapp -f
```

---

# 🔵 **8. Mask a service (BLOCK completely)**

Disables service from being started manually or automatically.

```
sudo systemctl mask <service>
```

Unmask:

```
sudo systemctl unmask <service>
```

---

# 🔵 **PRACTICAL TASK (Do this now)**

1️⃣ Check these services:

```
systemctl status sshd
systemctl status firewalld
systemctl status chronyd
```

2️⃣ Restart one service:

```
sudo systemctl restart firewalld
```

3️⃣ Enable chronyd:

```
sudo systemctl enable chronyd
```

4️⃣ View logs:

```
journalctl -u sshd -xe
```

Great — now we move to another **core OS-level topic** every Linux admin and DevOps engineer must master:

# 🚀 **STEP 6 — Networking in Linux (RHEL 9.7)**

You will learn IP, DNS, routes, firewall, hostname, network config basics — everything you need in real servers.

---

# 🔵 **1. Check IP Address**

Modern command:

```
ip addr
```

or shorter:

```
ip a
```

To see only active interfaces:

```
ip -brief addr
```

---

# 🔵 **2. Check Network Interfaces**

```
ip link
```

Bring interface up/down:

```
sudo ip link set enp0s3 up
sudo ip link set enp0s3 down
```

---

# 🔵 **3. Check Routing Table**

```
ip route
```

Example output:

```
default via 10.10.0.1 dev eth0
10.10.0.0/24 dev eth0 proto kernel scope link src 10.10.0.5
```

---

# 🔵 **4. Check DNS settings**

```
cat /etc/resolv.conf
```

Example:

```
nameserver 8.8.8.8
nameserver 1.1.1.1
```

---

# 🔵 **5. Check hostname**

```
hostname
hostnamectl
```

Change hostname:

```
sudo hostnamectl set-hostname nfs-server
```

---

# 🔵 **6. Ping & Connectivity**

Ping another system:

```
ping -c 4 google.com
```

Ping an IP:

```
ping -c 4 8.8.8.8
```

Check port (very important):

```
nc -zv 10.0.0.5 22
```

---

# 🔵 **7. Firewall (firewalld) — VERY IMPORTANT on RHEL**

### Check status:

```
sudo systemctl status firewalld
```

### List open ports:

```
sudo firewall-cmd --list-all
```

### Allow a port:

```
sudo firewall-cmd --add-port=8080/tcp --permanent
sudo firewall-cmd --reload
```

### Allow a service:

```
sudo firewall-cmd --add-service=nfs --permanent
sudo firewall-cmd --reload
```

---

# 🔵 **8. nmcli (NetworkManager CLI)**

This is the official network tool in RHEL.

### Show connections:

```
nmcli connection show
```

### Show active connection:

```
nmcli device status
```

### Configure static IP example:

```
sudo nmcli con mod ens160 ipv4.addresses 192.168.1.50/24
sudo nmcli con mod ens160 ipv4.gateway 192.168.1.1
sudo nmcli con mod ens160 ipv4.dns 8.8.8.8
sudo nmcli con mod ens160 ipv4.method manual
sudo nmcli con up ens160
```

---

# 🔵 **9. Check open network ports**

```
ss -tulnp
```

* `-t` = tcp
* `-u` = udp
* `-l` = listening
* `-n` = numeric
* `-p` = process

Example output:

```
LISTEN  0  80  0.0.0.0:22    0.0.0.0:*    users:(("sshd",pid=914,fd=3))
```

---

# 🔵 **10. Host file**

```
cat /etc/hosts
```

Add entry manually:

```
sudo sh -c 'echo "10.0.0.10   yb-master-1" >> /etc/hosts'
```

---

# 🔥 PRACTICAL TASK (Run these commands)

Execute these commands on your system:

```
ip a
ip route
cat /etc/resolv.conf
hostnamectl
ss -tulnp
sudo firewall-cmd --list-all
nmcli device status
```




Great — now we enter **one of the most critical real-world Linux admin topics**:

# 🚀 **STEP 7 — Storage & Filesystems (Disks, Mounting, LVM, fstab, partitions)**

This is extremely important for your NFS work, cloud disks, and production servers.

Let’s start step-by-step 🔥

---

# 🔵 **1. List All Disks**

```
lsblk
```

Example output:

```
sda     50G
 ├─sda1  1G   (boot)
 ├─sda2  30G  (root)
 └─sda3  19G  (home)
```

---

# 🔵 **2. Detailed Disk Info**

```
sudo fdisk -l
```

Shows partition tables, disk size, sectors.

---

# 🔵 **3. Create a Partition (MBR/GPT)**

Open interactive disk utility:

```
sudo fdisk /dev/sdb
```

Inside fdisk:

* `n` → new partition
* `p` → primary
* `1` → partition number
* press Enter for default size
* `w` → write/save changes

---

# 🔵 **4. Format a Partition**

### ext4:

```
sudo mkfs.ext4 /dev/sdb1
```

### xfs:

```
sudo mkfs.xfs /dev/sdb1
```

RHEL uses **XFS** as default.

---

# 🔵 **5. Create a Mount Point**

```
sudo mkdir /mnt/data
```

---

# 🔵 **6. Mount the Disk (Temporary)**

```
sudo mount /dev/sdb1 /mnt/data
```

Check:

```
df -h
```

---

# 🔵 **7. Make Mount Permanent — fstab (VERY IMPORTANT)**

Open:

```
sudo vi /etc/fstab
```

Add line:

```
/dev/sdb1   /mnt/data   xfs    defaults    0 0
```

Test (DO NOT reboot without testing):

```
sudo mount -a
```

If no errors → safe.

---

# 🔵 **8. Get UUID of Disk**

Better than using /dev/sdb1:

```
blkid
```

Example:

```
UUID="89a2-123f-78dd-bb2c"
```

Use it in fstab:

```
UUID=89a2-123f-78dd-bb2c   /mnt/data   xfs   defaults  0 0
```

---

# 🔵 **9. Unmount a Disk**

```
sudo umount /mnt/data
```

If “busy”, find process:

```
sudo lsof /mnt/data
```

---

# 🔵 **10. Logical Volume Manager (LVM)**

RHEL uses LVM a lot.

## Step 1: Create PV

```
sudo pvcreate /dev/sdb
```

## Step 2: Create VG

```
sudo vgcreate datavg /dev/sdb
```

## Step 3: Create LV

```
sudo lvcreate -L 10G -n datalv datavg
```

## Step 4: Format LV

```
sudo mkfs.xfs /dev/datavg/datalv
```

## Step 5: Mount LV

```
sudo mkdir /data
sudo mount /dev/datavg/datalv /data
```

---

# 🔵 **11. Check LVM Details**

```
pvs
vgs
lvs
```

---

# 🔵 **12. Resize LV**

### Extend:

```
sudo lvextend -r -L +5G /dev/datavg/datalv
```

`-r` = resize filesystem automatically.

---

# 🔵 **13. Check Disk IO**

```
iostat -x 2
```

---

# 🔥 PRACTICAL TASK (Do this now)\*\*

Run these commands on your server:

```
lsblk
blkid
sudo fdisk -l
df -h
sudo mount -a
pvs
vgs
lvs
```
