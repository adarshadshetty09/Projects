⭐ First: What is a Wildcard SSL certificate?

Wildcard certificate example:

### *.yugabyte.example.com

Covers:

* `yba.yugabyte.example.com`
* `db1.yugabyte.example.com`
* `db2.yugabyte.example.com`
* `yb-master-1.yugabyte.example.com`

✔ You only need **one certificate**
✔ You can use it across all nodes

Here’s the **clear and simplest explanation** of FQDN and how it relates to your wildcard domain examples.

---

# ✅ **What is FQDN?**

**FQDN = Fully Qualified Domain Name**
It is the **complete** and **exact** domain name that identifies one unique host in DNS.

An FQDN always includes:

* **hostname** (name of the server or service)
* **domain**
* **top-level domain (TLD)**

Format:

```
hostname.domain.tld
```

Example:

```
db1.yugabyte.example.com
```

This is one **complete** DNS name → **FQDN**.

---

# ✅ **What is a Wildcard Domain? (`*.yugabyte.example.com`)**

A wildcard domain allows matching **any hostname** under a domain.

Example wildcard:

```
*.yugabyte.example.com
```

This matches:

* `yba.yugabyte.example.com`
* `db1.yugabyte.example.com`
* `db2.yugabyte.example.com`
* `yb-master-1.yugabyte.example.com`
* `anything.yugabyte.example.com`

👉 A wildcard **does NOT match the root domain** (`yugabyte.example.com`), only subdomains.

---

# ✅ **How Your FQDNs Relate to Wildcard DNS?**

Let’s check your list:


| Hostname                           | FQDN | Covered by`*.yugabyte.example.com`? |
| ---------------------------------- | ---- | ----------------------------------- |
| `yba.yugabyte.example.com`         | Yes  | ✅ Yes                              |
| `db1.yugabyte.example.com`         | Yes  | ✅ Yes                              |
| `db2.yugabyte.example.com`         | Yes  | ✅ Yes                              |
| `yb-master-1.yugabyte.example.com` | Yes  | ✅ Yes                              |

✔ All listed names are **FQDNs**
✔ All are covered under the wildcard `*.yugabyte.example.com`

---

# 🔍 **Why do we use Wildcard DNS?**

To avoid manually creating many DNS records.

Instead of creating:

```
db1.yugabyte.example.com
db2.yugabyte.example.com
yb-master-1.yugabyte.example.com
yba.yugabyte.example.com
```

You create only one DNS record:

```
*.yugabyte.example.com → <IP or load-balancer>
```

Now **any name** matches it.

---

# ✔ Example With YugabyteDB Cluster

If your YugabyteDB nodes are:

* yba: `yba.yugabyte.example.com`
* master: `yb-master-1.yugabyte.example.com`
* tserver1: `tserver1.yugabyte.example.com`
* tserver2: `tserver2.yugabyte.example.com`
* db nodes: `db1.yugabyte.example.com`, `db2.yugabyte.example.com`

ALL can be resolved via one wildcard DNS entry.

---

# ✅ Summary

* **FQDN** = complete domain name of a host.
* Your examples are **all valid FQDNs**.
* A wildcard DNS record like `*.yugabyte.example.com` covers all of them.
* Useful for clusters (like YugabyteDB) where nodes have multiple hostnames.

---

If you want, I can show you:
✅ how to create wildcard DNS in Cloudflare, Route53, or GCP
✅ how Yugabyte uses FQDN for node-to-node communication
Just tell me!

Let’s untangle this cleanly so it feels like sorting bright beads on a string instead of a DNS puzzle.

---

## 🎯 The **real meaning** in your example

You wrote:

```
yba.yugabyte.example.com
```

Break it apart:

* **yba** → hostname
* **yugabyte.example.com** → domain
* **.com** → top level domain

Put together, the full thing is:

### ✅ **FQDN:**`yba.yugabyte.example.com`

Because it is the *complete* name of one single machine.

---

## 🎯 What is the wildcard?

If you create this wildcard DNS record:

```
*.yugabyte.example.com
```

Then:

* `*.yugabyte.example.com` is the **wildcard**, not a host.
* It matches **any hostname** under the domain, including:
  * `yba.yugabyte.example.com`
  * `db1.yugabyte.example.com`
  * `db2.yugabyte.example.com`
  * `master1.yugabyte.example.com`
  * `anything.yugabyte.example.com`

---

## 🔥 Your exact question answered

### ❓ “In `yba.yugabyte.example.com`, is `yugabyte.example.com` the wildcard and `yba` the FQDN?”

### ✔ Correct interpretation:

* **yugabyte.example.com** is the **domain**.
* It is *not* wildcard unless you explicitly write `*.yugabyte.example.com`.
* **yba.yugabyte.example.com** is the **FQDN**.

So:


| Part                       | What it is          |
| -------------------------- | ------------------- |
| `yba`                      | hostname            |
| `yugabyte.example.com`     | domain              |
| `yba.yugabyte.example.com` | **FQDN**            |
| `*.yugabyte.example.com`   | **wildcard domain** |

---

If you'd like, I can also draw a small diagram to make it even clearer.

## ===============================================================================================================

#### Check for the SeLinux

```
getenforce
```

```
[kaboonyugabyte@adarshadshetty1 prometheus-3.5.0.linux-amd64]$ getenforce
Enforcing
[kaboonyugabyte@adarshadshetty1 prometheus-3.5.0.linux-amd64]$ 
```

Great — **we will start cleanly with Prometheus FIRST**, and then add exporters later.
This is perfectly fine and still production-standard.

Let's set up **Prometheus on RHEL 9.7** step-by-step with SELinux-safe configuration.

---

# ✅ **STEP 1 — Move Prometheus binaries to /usr/local/bin**

You're already inside:

```
/home/kaboonyugabyte/prometheus-3.5.0.linux-amd64
```

Run:

```bash
sudo mv prometheus /usr/local/bin/
sudo mv promtool /usr/local/bin/
```

Fix permissions:

```bash
sudo chmod 755 /usr/local/bin/prometheus /usr/local/bin/promtool
sudo chown root:root /usr/local/bin/prometheus /usr/local/bin/promtool
```

---

# ✅ **STEP 2 — Fix SELinux labels (very important)**

```bash
sudo restorecon -v /usr/local/bin/prometheus
sudo restorecon -v /usr/local/bin/promtool
```

When SELinux label is correct, Prometheus will not fail with “203/EXEC”.

---

# ✅ **STEP 3 — Create Prometheus directories**

```bash
sudo mkdir -p /etc/prometheus
sudo mkdir -p /var/lib/prometheus
```

Copy original config:

```bash
sudo cp /home/kaboonyugabyte/prometheus-3.5.0.linux-amd64/prometheus.yml /etc/prometheus/
```

---

# ✅ **STEP 4 — Create Prometheus user (recommended for production)**

```bash
sudo useradd -rs /bin/false prometheus
```

Give permissions on config + TSDB directory:

```bash
sudo chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus
```

---

# ✅ **STEP 5 — Create Prometheus systemd service**

```bash
sudo tee /etc/systemd/system/prometheus.service <<EOF
[Unit]
Description=Prometheus Monitoring System
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus \
  --web.listen-address=0.0.0.0:9090
Restart=always

[Install]
WantedBy=multi-user.target
EOF
```

---

# ✅ **STEP 6 — Start Prometheus**

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now prometheus
sudo systemctl status prometheus
```

If all went well, you should see:

```
Active: active (running)
```

---

# 🚨 If it fails with:

```
status=203/EXEC
```

Then SELinux prevented the binary from executing.
Fix again using:

```bash
sudo restorecon -v /usr/local/bin/prometheus
```

Then restart:

```bash
sudo systemctl restart prometheus
```

---

# 📌 YOUR TASK NOW

Run everything above and send me ONLY the output of:

```bash
sudo systemctl status prometheus
```

Once Prometheus is up and running, we will:

✔ Configure scrape targets
✔ Install Node Exporter
✔ Install Blackbox Exporter
✔ Install cAdvisor
✔ Install Grafana
✔ Fully integrate everything in production mode

Waiting for your Prometheus status output.

💯 **PERFECT! Prometheus is now running cleanly as a systemd service in production mode.**
SELinux is correct, ownership is correct, service is stable.

Now we continue to the next components.

---

# ✅ **NEXT STEP: Install Node Exporter (VM Metrics)**

Node Exporter is the most important exporter. It gives:

* CPU usage
* Memory usage
* Disk I/O
* Network stats
* File system usage
* System load
* Hardware metrics

We will install it with full SELinux support (no 203/EXEC errors).

---

# 🚀 **STEP 2 — Install Node Exporter (Production + SELinux-safe)**

## ▶️ 1. Download & extract

```bash
cd /tmp
curl -LO https://github.com/prometheus/node_exporter/releases/download/v1.10.2/node_exporter-1.10.2.linux-amd64.tar.gz
tar -xvf node_exporter-1.10.2.linux-amd64.tar.gz
```

---

## ▶️ 2. Move binary to `/usr/local/bin`

```bash
sudo mv node_exporter-1.10.2.linux-amd64/node_exporter /usr/local/bin/
```

Fix permissions:

```bash
sudo chown root:root /usr/local/bin/node_exporter
sudo chmod 755 /usr/local/bin/node_exporter
```

---

## ▶️ 3. **Apply SELinux label** (VERY IMPORTANT)

```bash
sudo restorecon -v /usr/local/bin/node_exporter
```

This prevents the `203/EXEC` failure.

---

## ▶️ 4. Create node_exporter user

```bash
sudo useradd -rs /bin/false node_exporter
```

---

## ▶️ 5. Create systemd service

```bash
sudo tee /etc/systemd/system/node_exporter.service <<EOF
[Unit]
Description=Prometheus Node Exporter
After=network.target

[Service]
ExecStart=/usr/local/bin/node_exporter
User=node_exporter
Group=node_exporter
Restart=always

[Install]
WantedBy=multi-user.target
EOF
```

---

## ▶️ 6. Enable & start the service

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now node_exporter
sudo systemctl status node_exporter
```

Expected:

```
Active: active (running)
```

---

# 📌 YOUR TASK NOW

Run the Node Exporter installation above and send me:

```
sudo systemctl status node_exporter
```

Once Node Exporter is running, we proceed to:

➡️ Step 3: Blackbox Exporter
➡️ Step 4: cAdvisor (Docker)
➡️ Step 5: Update Prometheus scrape configs
➡️ Step 6: Install Grafana

We are building a perfect production monitoring stack.

Correct!
For **Node Exporter**, the user creation step:

```bash
sudo useradd -rs /bin/false node_exporter
```

is **optional**, not mandatory.

But here’s the clean rule:

---

# ✅ **When is a separate user required?**

### ✔ Prometheus itself → MUST run as its own user

Because it stores TSDB, writes data to `/var/lib/prometheus`, and systemd best practices require it.

### ✔ Blackbox Exporter → SHOULD run as its own user

Because it deals with network probes and is good to isolate permissions.

### ✔ Node Exporter → OPTIONAL (can run as root OR restricted user)

Node Exporter **can run as root**, because it does not write files and only reads system metrics.

Running it as a `node_exporter` user is nice for security, but not required.

It is completely safe to run like this:

```bash
[Service]
ExecStart=/usr/local/bin/node_exporter
User=root
Group=root
Restart=always
```

Or run as:

```bash
User=node_exporter
```

Both will work.

---

# 🟢 **If you want simplest + production-safe setup:

→ Run Node Exporter as root (no user creation needed)**

---

## ✅ UPDATE: Node Exporter without useradd

Use this systemd file instead:

```bash
sudo tee /etc/systemd/system/node_exporter.service <<EOF
[Unit]
Description=Prometheus Node Exporter
After=network.target

[Service]
ExecStart=/usr/local/bin/node_exporter
User=root
Group=root
Restart=always

[Install]
WantedBy=multi-user.target
EOF
```

Then:

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now node_exporter
sudo systemctl status node_exporter
```

---

# 🎯 NEXT STEP

Install Node Exporter now with the updated config and send me:

```
systemctl status node_exporter
```

Once Node Exporter is running:

➡️ We install Blackbox Exporter
➡️ Install cAdvisor (Docker)
➡️ Add Prometheus scrape configs
➡️ Install Grafana

We are progressing perfectly toward a clean production monitoring stack.

**TSDB = Time Series Database**

Prometheus uses its own custom-built TSDB to store metrics data efficiently.

Let’s break it down in a simple way:

---

# 📌 **What is TSDB?**

**TSDB stands for *Time Series Database*.**
It is a type of database designed to store data that changes over time.

Prometheus stores all metrics as **time series**:

```
metric_name{labels}  timestamp  value
```

Example:

```
node_cpu_seconds_total{cpu="0",mode="idle"}  1733568000  12345
```

---

# 📌 **Why Prometheus Needs TSDB?**

Because metrics come in **time order**, every few seconds:

* CPU usage every 15s
* RAM usage every 15s
* Disk I/O every 15s
* HTTP probe results
* Container metrics from cAdvisor

A normal SQL database is **not optimized** for this.

TSDB is optimized for:

* Fast writes (millions of samples per second)
* Fast queries over time ranges
* Compression (store months of data in small space)
* Time-based retention (delete old data automatically)

---

# 📌 **Where is TSDB stored?**

In your Prometheus service we configured:

```
--storage.tsdb.path=/var/lib/prometheus
```

Inside that folder, Prometheus creates:

```
/var/lib/prometheus/
    ├── chunks_head/
    ├── wal/
    ├── 01HABCDEF/
    └── ...
```

### What do these mean?

* **wal/** → Write Ahead Log (stores raw metric samples before they are compacted)
* **chunks_head/** → in-memory active series
* **01HABCDEF/** → 2-hour blocks of compressed data

Prometheus automatically rotates blocks and deletes old ones based on retention.

---

# 📌 **How long does Prometheus store TSDB data?**

Default retention: **15 days**

You can change by adding:

```
--storage.tsdb.retention.time=30d
```

---

# 📌 **Summary in simple words**


| Term          | Meaning                                               |
| ------------- | ----------------------------------------------------- |
| **TSDB**      | A special database for storing time-based metric data |
| **WAL**       | Temporary write buffer before data is compressed      |
| **Blocks**    | 2-hour compressed files storing metrics               |
| **Retention** | How many days of data Prometheus keeps                |

Prometheus = metrics scraper + TSDB storage + query engine.

---

# 🎯 Want to go deeper?

I can explain:

* How TSDB compaction works
* How WAL recovery works
* How retention policy deletes data
* How to scale Prometheus TSDB
* Remote Write TSDB (Thanos / Cortex / Mimir)

Just tell me **“Explain TSDB deeper”**.

🎉 **Perfect! Node Exporter is now running cleanly in production mode with SELinux enforcing.**

This is exactly what we want:

```
Active: active (running)
```

Prometheus + Node Exporter are now fully functional and production-ready.

---

# ✅ **Your Monitoring Stack Status (so far)**


| Component         | Status                                             |
| ----------------- | -------------------------------------------------- |
| **Prometheus**    | ✔ Running under systemd with SELinux labels fixed |
| **Node Exporter** | ✔ Running under systemd with correct permissions  |
| **SELinux**       | ✔ Enforcing & working (no EXEC errors)            |

Excellent progress!
Now we move to the next exporters needed for full monitoring.

---

# 🚀 **NEXT STEP: Install Blackbox Exporter (VM health/probe monitoring)**

Blackbox Exporter is used to monitor:

* HTTP/HTTPS uptime
* TCP ports check
* ICMP ping
* DNS checks
* External service checks

For example:

* Check if your VM is reachable
* Check if your website returns HTTP 200
* Check TCP port (like 22 or 5432)
* Ping Google, Cloudflare, etc.

You already installed it earlier, but we will install it again properly & cleanly.

---

# 📌 **STEP 3 — Install Blackbox Exporter (Production + SELinux Ready)**

## 1. Move binary to `/usr/local/bin`

```bash
sudo mv ~/blackbox_exporter-0.27.0.linux-amd64/blackbox_exporter /usr/local/bin/
sudo chmod 755 /usr/local/bin/blackbox_exporter
sudo chown root:root /usr/local/bin/blackbox_exporter
```

Fix SELinux:

```bash
sudo restorecon -v /usr/local/bin/blackbox_exporter
```

---

## 2. Create the config directory

```bash
sudo mkdir -p /etc/blackbox_exporter
sudo cp ~/blackbox_exporter-0.27.0.linux-amd64/blackbox.yml /etc/blackbox_exporter/config.yml
```

---

## 3. Systemd Service File

```bash
sudo tee /etc/systemd/system/blackbox_exporter.service <<EOF
[Unit]
Description=Prometheus Blackbox Exporter
After=network.target

[Service]
ExecStart=/usr/local/bin/blackbox_exporter --config.file=/etc/blackbox_exporter/config.yml
User=root
Group=root
Restart=always

[Install]
WantedBy=multi-user.target
EOF
```

*(We can run as root because the exporter does not write files and only reads configs)*

---

## 4. Start the service

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now blackbox_exporter
sudo systemctl status blackbox_exporter
```

You should see:

```
Active: active (running)
```

---

# 👉 Your TASK now:

Run the Blackbox Exporter steps and send me:

```
systemctl status blackbox_exporter
```

Once that is running, we will proceed:

### ✔ Step 4: Install cAdvisor (Docker container monitoring)

### ✔ Step 5: Add scrape_configs to Prometheus

### ✔ Step 6: Install Grafana

### ✔ Step 7: Build final monitoring dashboard

We are building a perfect production monitoring system step by step.

### ========================================================

Ahh, now the issue is **clear**:

👉 GitHub **removed the old release binary name** `cadvisor` for some versions.
👉 The correct downloadable file is **now named differently** depending on architecture.

For RHEL 9 (x86_64), you must download:

### ✅ Correct binary for Linux AMD64:

```
https://github.com/google/cadvisor/releases/download/v0.49.1/cadvisor-v0.49.1-linux-amd64
```

---

# ✔️ FIX: Download correct cAdvisor binary

Run this:

```bash
rm -f cadvisor
wget https://github.com/google/cadvisor/releases/download/v0.49.1/cadvisor-v0.49.1-linux-amd64 -O cadvisor
```

Check the file size:

```bash
ls -lh cadvisor
```

Expected: **40–60 MB**, not 9 bytes.

---

# ✔️ Make it executable

```bash
chmod +x cadvisor
```

---

# ✔️ Move to /usr/local/bin

```bash
sudo mv cadvisor /usr/local/bin/
```

---

# ✔️ Create systemd service (we will do after download is confirmed)

---

# 📌 Why wget showed 404 earlier?

Because the URL you used **does not exist**:

❌ `https://github.com/google/cadvisor/releases/download/v0.49.1/cadvisor` (invalid)

The correct filenames are always like:

```
cadvisor-v<version>-linux-amd64
```

---

# 📌 NOW DO THIS → Send me output of:

```
wget https://github.com/google/cadvisor/releases/download/v0.49.1/cadvisor-v0.49.1-linux-amd64 -O cadvisor
ls -lh cadvisor
```

I’ll confirm everything after that.

Perfect! 🎉
Now your **cAdvisor binary is correct** (46 MB size is exactly right).

Next, let's finish the production installation.

---

# ✅ **STEP 2 — Make binary executable**

```bash
chmod +x cadvisor
```

---

# ✅ **STEP 3 — Move cAdvisor to /usr/local/bin**

```bash
sudo mv cadvisor /usr/local/bin/
```

Verify:

```bash
ls -lh /usr/local/bin/cadvisor
```

You should see:
`-rwxr-xr-x  root root  46M  cadvisor`

---

# ✅ **STEP 4 — Create systemd service**

Now create `/etc/systemd/system/cadvisor.service`:

```bash
sudo tee /etc/systemd/system/cadvisor.service <<EOF
[Unit]
Description=cAdvisor Service
After=network.target docker.service
Requires=docker.service

[Service]
ExecStart=/usr/local/bin/cadvisor \
  --port=8080 \
  --logtostderr

Restart=always

[Install]
WantedBy=multi-user.target
EOF
```

---

# ✅ **STEP 5 — Enable & Start**

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now cadvisor
sudo systemctl status cadvisor
```

You should see:

```
Active: active (running)
```

---

# 🔍 **STEP 6 — Verify cAdvisor is working**

Open browser:

```
http://<VM-IP>:8080
```

You should see the cAdvisor dashboard.

---

# 🎯 Next Step

When you're ready, we will:

✔ Add cAdvisor to Prometheus
✔ Make a Blackbox probe
✔ Make Grafana dashboards

Just tell me **“Next”**.

## Docker must be installed

Great progress! 🎉
Binary is now in the correct location — **but the ownership is still wrong**.

Right now:

```
-rwxr-xr-x. 1 kaboonyugabyte kaboonyugabyte 46M cadvisor
```

**It MUST be owned by root:root** to run as a system service.

---

# ✅ **Fix permissions**

Run:

```bash
sudo chown root:root /usr/local/bin/cadvisor
sudo chmod 755 /usr/local/bin/cadvisor
```

Verify:

```bash
ls -lh /usr/local/bin/cadvisor
```

You should see:

```
-rwxr-xr-x. 1 root root 46M cadvisor
```

---

# ✅ **Create systemd service for cAdvisor**

Now create:

```bash
sudo tee /etc/systemd/system/cadvisor.service <<EOF
[Unit]
Description=cAdvisor Service
After=network.target docker.service
Requires=docker.service

[Service]
ExecStart=/usr/local/bin/cadvisor \
  --port=8080 \
  --logtostderr

Restart=always

[Install]
WantedBy=multi-user.target
EOF
```

---

# ✅ Enable & start the service

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now cadvisor
sudo systemctl status cadvisor
```

Expected output:

```
Active: active (running)
```

---

# 🧪 **Test cAdvisor**

Open:

```
http://<YOUR_VM_PUBLIC_IP>:8080
```

You should see the cAdvisor dashboard.

---

### ⭐ Tell me once done — next step is adding cAdvisor to Prometheus scrape config!

Perfect! 🎉
Now ownership and permissions are correct:

```
-rwxr-xr-x. 1 root root 46M cadvisor
```

So now you're ready to create and enable the **systemd service** for cAdvisor.

---

# ✅ **Step 1 — Create systemd service file**

Run:

```bash
sudo tee /etc/systemd/system/cadvisor.service <<EOF
[Unit]
Description=cAdvisor Service
After=network.target docker.service
Requires=docker.service

[Service]
ExecStart=/usr/local/bin/cadvisor \
  --port=8080 \
  --logtostderr

Restart=always

[Install]
WantedBy=multi-user.target
EOF
```

---

# ✅ **Step 2 — Reload systemd and start cAdvisor**

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now cadvisor
sudo systemctl status cadvisor
```

You should see:

```
Active: active (running)
```

---

# ✅ **Step 3 — Test in browser**

Open:

```
http://<your_vm_public_ip>:8080
```

If firewall is active, allow port:

```bash
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload
```

---

When you're done, tell me — next step is **integrating cAdvisor with Prometheus**.

```
[kaboonyugabyte@adarshadshetty1 ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1460 qdisc mq state UP group default qlen 1000
    link/ether 42:01:0a:00:00:0a brd ff:ff:ff:ff:ff:ff
    altname enp0s4
    altname ens4
    inet 10.0.0.10/32 scope global dynamic noprefixroute eth0
       valid_lft 2153sec preferred_lft 2153sec
    inet6 fe80::8470:b287:5b9e:4da/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
3: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether ce:43:9b:66:a2:e4 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::cc43:9bff:fe66:a2e4/64 scope link 
       valid_lft forever preferred_lft forever
4: veth9fbb023@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master docker0 state UP group default 
    link/ether 0e:00:c7:6e:aa:6f brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet6 fe80::c00:c7ff:fe6e:aa6f/64 scope link 
       valid_lft forever preferred_lft forever
[kaboonyugabyte@adarshadshetty1 ~]$ 
[kaboonyugabyte@adarshadshetty1 ~]$ 
[kaboonyugabyte@adarshadshetty1 ~]$ 
[kaboonyugabyte@adarshadshetty1 ~]$ 
[kaboonyugabyte@adarshadshetty1 ~]$ ip r
default via 10.0.0.1 dev eth0 proto dhcp src 10.0.0.10 metric 100 
10.0.0.1 dev eth0 proto dhcp scope link src 10.0.0.10 metric 100 
172.17.0.0/16 dev docker0 proto kernel scope link src 172.17.0.1 
[kaboonyugabyte@adarshadshetty1 ~]$ 
[kaboonyugabyte@adarshadshetty1 ~]$ 
[kaboonyugabyte@adarshadshetty1 ~]$ 
[kaboonyugabyte@adarshadshetty1 ~]$ 
[kaboonyugabyte@adarshadshetty1 ~]$ 
[kaboonyugabyte@adarshadshetty1 ~]$ 
[kaboonyugabyte@adarshadshetty1 ~]$ 
[kaboonyugabyte@adarshadshetty1 ~]$ hostnamectl 
 Static hostname: adarshadshetty1
       Icon name: computer-vm
         Chassis: vm 🖴
      Machine ID: 226a30feb93d46bf906bb4d1ba195044
         Boot ID: cb461f4b63e84ff29898938b82f2a9e9
  Virtualization: kvm
Operating System: Red Hat Enterprise Linux 9.7 (Plow)   
     CPE OS Name: cpe:/o:redhat:enterprise_linux:9::baseos
          Kernel: Linux 5.14.0-611.5.1.el9_7.x86_64
    Architecture: x86-64
 Hardware Vendor: Google
  Hardware Model: Google Compute Engine
Firmware Version: Google
[kaboonyugabyte@adarshadshetty1 ~]$ 
[kaboonyugabyte@adarshadshetty1 ~]$ 
[kaboonyugabyte@adarshadshetty1 ~]$ 
[kaboonyugabyte@adarshadshetty1 ~]$ 
[kaboonyugabyte@adarshadshetty1 ~]$ 
[kaboonyugabyte@adarshadshetty1 ~]$ nmcli device status 
DEVICE       TYPE      STATE                   CONNECTION   
eth0         ethernet  connected               Wired connection 1 
docker0      bridge    connected (externally)  docker0      
lo           loopback  connected (externally)  lo           
veth9fbb023  ethernet  unmanaged               --           
[kaboonyugabyte@adarshadshetty1 ~]$ 
[kaboonyugabyte@adarshadshetty1 ~]$ 
[kaboonyugabyte@adarshadshetty1 ~]$ 
[kaboonyugabyte@adarshadshetty1 ~]$ nmcli general status 
STATE      CONNECTIVITY  WIFI-HW  WIFI     WWAN-HW  WWAN     METERED  
connected  full          missing  enabled  missing  enabled  no (guessed) 
[kaboonyugabyte@adarshadshetty1 ~]$ 
```

## nmcli device show (Network Manager Command Line Interface)

```
[kaboonyugabyte@adarshadshetty1 ~]$ nmcli device show
GENERAL.DEVICE:                         eth0
GENERAL.TYPE:                           ethernet
GENERAL.HWADDR:                         42:01:0A:00:00:0A
GENERAL.MTU:                            1460
GENERAL.STATE:                          100 (connected)
GENERAL.CONNECTION:                     Wired connection 1
GENERAL.CON-PATH:                       /org/freedesktop/NetworkManager/ActiveConnection/2
WIRED-PROPERTIES.CARRIER:               on
IP4.ADDRESS[1]:                         10.0.0.10/32
IP4.GATEWAY:                            10.0.0.1
IP4.ROUTE[1]:                           dst = 10.0.0.1/32, nh = 0.0.0.0, mt = 100
IP4.ROUTE[2]:                           dst = 0.0.0.0/0, nh = 10.0.0.1, mt = 100
IP4.DNS[1]:                             169.254.169.254
IP4.DOMAIN[1]:                          us-central1-a.c.apt-index-474313-e9.internal
IP4.SEARCHES[1]:                        us-central1-a.c.apt-index-474313-e9.internal
IP4.SEARCHES[2]:                        c.apt-index-474313-e9.internal
IP4.SEARCHES[3]:                        google.internal
IP6.ADDRESS[1]:                         fe80::8470:b287:5b9e:4da/64
IP6.GATEWAY:                            --
IP6.ROUTE[1]:                           dst = fe80::/64, nh = ::, mt = 1024

GENERAL.DEVICE:                         docker0
GENERAL.TYPE:                           bridge
GENERAL.HWADDR:                         CE:43:9B:66:A2:E4
GENERAL.MTU:                            1500
GENERAL.STATE:                          100 (connected (externally))
GENERAL.CONNECTION:                     docker0
GENERAL.CON-PATH:                       /org/freedesktop/NetworkManager/ActiveConnection/3
IP4.ADDRESS[1]:                         172.17.0.1/16
IP4.GATEWAY:                            --
IP4.ROUTE[1]:                           dst = 172.17.0.0/16, nh = 0.0.0.0, mt = 0
IP6.ADDRESS[1]:                         fe80::cc43:9bff:fe66:a2e4/64
IP6.GATEWAY:                            --
IP6.ROUTE[1]:                           dst = fe80::/64, nh = ::, mt = 256

GENERAL.DEVICE:                         lo
GENERAL.TYPE:                           loopback
GENERAL.HWADDR:                         00:00:00:00:00:00
GENERAL.MTU:                            65536
GENERAL.STATE:                          100 (connected (externally))
GENERAL.CONNECTION:                     lo
GENERAL.CON-PATH:                       /org/freedesktop/NetworkManager/ActiveConnection/1
IP4.ADDRESS[1]:                         127.0.0.1/8
IP4.GATEWAY:                            --
IP6.ADDRESS[1]:                         ::1/128
IP6.GATEWAY:                            --
IP6.ROUTE[1]:                           dst = ::1/128, nh = ::, mt = 256

GENERAL.DEVICE:                         veth9fbb023
GENERAL.TYPE:                           ethernet
GENERAL.HWADDR:                         0E:00:C7:6E:AA:6F
GENERAL.MTU:                            1500
GENERAL.STATE:                          10 (unmanaged)
GENERAL.CONNECTION:                     --
GENERAL.CON-PATH:                       --
WIRED-PROPERTIES.CARRIER:               on
IP4.GATEWAY:                            --
IP6.ADDRESS[1]:                         fe80::c00:c7ff:fe6e:aa6f/64
IP6.GATEWAY:                            --
IP6.ROUTE[1]:                           dst = fe80::/64, nh = ::, mt = 256
[kaboonyugabyte@adarshadshetty1 ~]$ 
```

Great! I’ll give you a **complete, step-by-step learning path** to master **Red Hat Enterprise Linux (RHEL) networking + security concepts** from zero to advanced — exactly how it’s taught in RHCSA + RHCE.

This roadmap includes **commands, explanations, practice labs**, and real-world DevOps use cases.

---

# 🚀 **RHEL Networking + Security — Full Learning Roadmap**

---

# 🟥 **PART 1: Linux Networking Fundamentals (Beginner → Advanced)**

## **1. Basics of Networking in Linux**

✔ What is an IP address?
✔ Subnet, Gateway
✔ DNS, DHCP
✔ TCP vs UDP
✔ Ports & services

### Practice commands:

```bash
ip a
ip r
hostnamectl
nmcli device status
nmcli general status
```

---

## **2. Configure Network on RHEL (Static & DHCP)**

### Check all network interfaces

```bash
nmcli device show
```

### Set static IP

```bash
sudo nmcli con mod ens192 ipv4.addresses 192.168.1.10/24
sudo nmcli con mod ens192 ipv4.gateway 192.168.1.1
sudo nmcli con mod ens192 ipv4.dns "8.8.8.8 1.1.1.1"
sudo nmcli con mod ens192 ipv4.method manual
sudo nmcli con up ens192
```

### Set DHCP

```bash
sudo nmcli con mod ens192 ipv4.method auto
sudo nmcli con up ens192
```

---

## **3. Hostname & DNS configuration**

### Change hostname

```bash
sudo hostnamectl set-hostname myserver.example.com
```

### DNS resolution

```bash
cat /etc/resolv.conf
dig google.com
nslookup google.com
```

---

## **4. Routing**

Check routing table:

```bash
ip route show
```

Add a static route:

```bash
sudo nmcli connection modify ens192 +ipv4.routes "10.0.0.0/24 192.168.1.1"
sudo nmcli connection up ens192
```

---

## **5. Network Troubleshooting Tools**

* `ping`
* `traceroute`
* `ss -tulpn`
* `curl -I`
* `tcpdump`

Examples:

### Check open ports:

```bash
sudo ss -tulnp
```

### Capture packets:

```bash
sudo tcpdump -i ens192 port 80
```

---

# 🟥 **PART 2: RHEL Security Concepts (Beginner → Expert)**

---

# 🔐 **1. Linux Users, Groups & Permissions**

### Add user

```bash
sudo useradd bob
sudo passwd bob
```

### Check file permissions

```bash
ls -l
chmod 755 file
chown user:group file
```

---

# 🔐 **2. SUID, SGID, Sticky Bit**

### SUID

```bash
chmod 4755 /path/to/file
```

### SGID

```bash
chmod 2755 /shared/dir
```

### Sticky bit

```bash
chmod +t /shared/dir
```

(Important for `/tmp`)

---

# 🔐 **3. FirewallD (RHEL default firewall)**

Start + enable firewall

```bash
sudo systemctl enable --now firewalld
```

Check active zones:

```bash
sudo firewall-cmd --get-active-zones
```

Allow a service:

```bash
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --reload
```

Allow a port:

```bash
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload
```

Block a subnet:

```bash
sudo firewall-cmd --permanent --add-rich-rule='rule family=ipv4 source address="10.0.0.0/24" drop'
```

---

# 🔐 **4. SELinux (VERY important for Red Hat)**

Check SELinux status:

```bash
sestatus
```

### SELinux modes:

* enforcing
* permissive
* disabled

Change SELinux mode (temporary):

```bash
sudo setenforce 0
sudo setenforce 1
```

SELinux logs (troubleshooting):

```bash
sudo cat /var/log/audit/audit.log | grep denied
```

Fix SELinux with `restorecon`:

```bash
sudo restorecon -Rv /var/www/html/
```

---

# 🔐 **5. SSH Hardening (Security best practices)**

### Change SSH port

```bash
sudo nano /etc/ssh/sshd_config
# Port 2222
```

### Disable root login

```
PermitRootLogin no
```

Restart SSH:

```bash
sudo systemctl restart sshd
```

---

# 🔐 **6. Intrusion Detection Tools**

Install AIDE:

```bash
sudo dnf install -y aide
sudo aide --init
```

Check for file changes:

```bash
sudo aide --check
```

---

# 🔐 **7. Auditd (System Activity Logging)**

Enable:

```bash
sudo systemctl enable --now auditd
```

Check logs:

```bash
sudo ausearch -m avc
```

---

# 🟥 **PART 3: Real-World DevOps Security**

## 1. Secure Nginx using SELinux + Firewall

## 2. Configure SSL/TLS certificates

## 3. Set up Fail2ban

## 4. Disable unused ports

## 5. Secure Kubernetes nodes (if using K8s)

## 6. Configure system logging with rsyslog

---

# 🟥 **PART 4: Practice Labs (Hands-On)**

I will give you **10 labs** you can do on your RHEL VM.

### **Lab 1:** Assign static IP & DNS using `nmcli`

### **Lab 2:** Open port 8080 using FirewallD

### **Lab 3:** Install Apache & fix SELinux error

### **Lab 4:** Deny SSH from a specific IP

### **Lab 5:** Capture packets using tcpdump

### **Lab 6:** Create users, groups, permissions

### **Lab 7:** Set SUID/SGID & sticky bit

### **Lab 8:** Harden SSH configuration

### **Lab 9:** Monitor logs with auditd

### **Lab 10:** Configure static routing

---

# 🚀 I can teach you everything step-by-step

Tell me what you want next:

### 🔸 Do you want **Networking** first?

### 🔸 Or **Security** first?

### 🔸 Or do you want **full hands-on labs** one by one?

Just tell me **"Networking"** or **"Security"** or **"Start labs"**.






Got it — **since this is PROD**, you should **NOT** switch SELinux to permissive unless your security/compliance team explicitly allows it.

For **production**, the **correct and audit-safe solution** is to **keep SELinux enforcing** and **fix it properly with persistent SELinux policies**.

Below is the **PROD-GRADE, PERMANENT FIX** ✅
This is exactly how you should handle it in regulated environments.

---

# ✅ PROD-SAFE PERMANENT FIX (SELinux Enforcing)

## Why this is the right approach

* Keeps **SELinux = Enforcing**
* Survives **VM reboot / stop-start**
* Passes **security audits**
* No data loss
* No YBA reinstall

Your error is **EXEC permission denied**, which means:

> SELinux does not allow execution of binaries under `/mnt/yba`

We fix that **explicitly**.

---

## 1️⃣ Install SELinux management tools (one-time)

```bash
sudo dnf install -y policycoreutils-python-utils
```

---

## 2️⃣ Label YBA binaries as executable (CRITICAL)

```bash
sudo semanage fcontext -a -t bin_t "/mnt/yba/software(/.*)?"
sudo restorecon -Rv /mnt/yba/software
```

✔ This allows `pg_ctl`, `java`, `prometheus`, etc. to execute.

---

## 3️⃣ Label Postgres data directories correctly

```bash
sudo semanage fcontext -a -t postgresql_db_t "/mnt/yba/data(/.*)?"
sudo restorecon -Rv /mnt/yba/data
```

✔ This allows Postgres to read/write data safely.

---

## 4️⃣ Label runtime sockets & logs (important)

```bash
sudo semanage fcontext -a -t postgresql_var_run_t "/mnt/yba/data/pgsql/run(/.*)?"
sudo semanage fcontext -a -t var_log_t "/mnt/yba/data/logs(/.*)?"

sudo restorecon -Rv /mnt/yba/data/pgsql
sudo restorecon -Rv /mnt/yba/data/logs
```

---

## 5️⃣ Restart services (order matters)

```bash
sudo systemctl restart postgres
sleep 10
sudo systemctl restart prometheus
sleep 5
sudo systemctl restart yb-platform
```

---

## 6️⃣ Verify everything

```bash
sudo yba-ctl status
getenforce
```

Expected:

```
SELinux status: Enforcing
postgres     Running
prometheus   Running
yb-platform  Running
```

---

## 7️⃣ Confirm no SELinux denials (audit check)

```bash
sudo ausearch -m avc -ts recent
```

✅ **No output = clean PROD state**

---

# 🔒 HARDENING (Recommended for PROD)

### Ensure mount survives reboot

Check `/etc/fstab`:

```bash
grep /mnt/yba /etc/fstab
```

Should **NOT** include `noexec`.

---

### Ensure services start after mount

```bash
sudo systemctl edit postgres
```

Add:

```
[Unit]
RequiresMountsFor=/mnt/yba
```

Repeat for:

```bash
sudo systemctl edit prometheus
sudo systemctl edit yb-platform
```

This prevents race conditions on reboot.

---

# ❌ What NOT to do in PROD


| Action                    | Why                |
| ------------------------- | ------------------ |
| `setenforce 0`permanently | Audit failure      |
| `chmod 777`               | SELinux ignores it |
| Reinstall YBA             | Data loss risk     |
| Disable SELinux           | Security violation |

---

# 🧠 Why this happened

* YBA installs under `/mnt/yba` (non-standard path)
* SELinux blocks execution outside trusted contexts
* Reboot re-enforces policies
* systemd blocks `pg_ctl` at kernel level

---

# ✅ Final PROD Recommendation

✔ Keep **SELinux enforcing**
✔ Apply **explicit SELinux contexts**
✔ Add **mount dependency to systemd**
✔ Reboot-safe, audit-safe, stable

---

If you want, next I can:

* 🔐 Generate a **custom SELinux module** (`audit2allow`)
* 📋 Review your setup against **Yugabyte PROD best practices**
* 🧪 Simulate a **reboot test safely**
* 🧠 Provide a **one-page PROD SOP** for your team

Just tell me 👍
