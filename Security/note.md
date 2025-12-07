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

| Component         | Status                                            |
| ----------------- | ------------------------------------------------- |
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
