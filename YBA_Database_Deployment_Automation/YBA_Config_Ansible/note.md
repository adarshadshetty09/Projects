## Install the Ansible

```
sudo dnf install -y ansible-core
```

### Option A — Preferred (uses `community.general.parted` + UUID in /etc/fstab)

#### Install the collection once

```
ansible-galaxy collection install community.general
```
