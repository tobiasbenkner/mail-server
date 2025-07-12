# Stalwart Mail Server with Traefik Reverse Proxy

This guide outlines the steps to set up a secure, modern mail server using [Stalwart Mail Server](https://stalw.art) in combination with the [Traefik](https://traefik.io) reverse proxy on Debian. The setup is optimized for a single node setup and emphasizes security, maintainability, and proper DNS and port configuration.

---

## 🧾 Requirements

- **Operating System:** Debian (e.g. Debian 12 Bookworm)
- **Recommended Hardware:**  
  2 vCPUs and 4 GB of RAM are sufficient for up to 10 users.
- **Antivirus:** Antivirus software is not included in this setup.  
  **TODO:** Integrate [ClamAV](https://www.clamav.net/) for basic virus scanning functionality.
- **Access:** Root or a user with `sudo` privileges is required.


## 🌐 Network & Ports


### ✳️ **Essential Ports (must remain open):**

| Port | Protocol | Purpose |
|------|----------|---------|
| 25   | SMTP     | Receives incoming email from other mail servers |
| 465  | SMTPS    | Secure submission of outbound mail using implicit TLS (recommended over port 587) |
| 993  | IMAPS    | Secure access to mailboxes using IMAP over TLS |
| 443  | HTTPS    | Required for web access, JMAP, REST API, admin panel, ACME (Let's Encrypt), MTA-STS, and more |


### 🚫 **Optional/Non-essential Ports (can be closed if not used):**

| Port | Purpose |
|------|---------|
| 587  | STARTTLS-based mail submission (can be disabled if using 465 only) |
| 143  | Unencrypted IMAP – should be disabled for security |
| 4190 | ManageSieve for remote Sieve rule management – only open if needed |
| 110/995 | POP3/POP3S – legacy protocols, not recommended unless required |
| 8080 | HTTP – useful during setup only; disable afterward to prevent unencrypted access |


## 🛠️ Server Preparation

The following steps prepare your server by updating the system, setting the hostname and timezone, and installing Docker and Git.


```bash
export DOMAIN=mail.benkner-it.com

##########################
# Update System
##########################
apt update && apt upgrade -y

##########################
# Server Settings
##########################

# set hostname
echo ${DOMAIN} > /etc/hostname

# set hostname to localhost ip
echo 127.0.0.1 ${DOMAIN} >> /etc/hostname

#set timezone
timedatectl set-timezone Europe/Berlin


##########################
# Install Git
##########################
apt install -y git

##########################
# Install Docker
##########################

# Add Docker Repository Key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker Repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update Sources
apt update

# Install Docker
apt install docker-ce docker-ce-cli containerd.io

# Start Docker Service
systemctl start docker
systemctl enable docker

# Add user to Docker-Group
[ "$USER" != "root" ] && usermod -aG docker $USER

# Check installation
docker --version
docker run hello-world

##########################
# Reboot
##########################
reboot
```

## 🌍 DNS Configuration
To ensure proper mail delivery and secure access, configure the following DNS records for your domain:

# DNS-Einträge für `benkner-it.com`

## A and AAAA Records

| Hostname              | Type | Value                                    |
|-----------------------|------|------------------------------------------|
| `mail.benkner-it.com` | A    | 142.132.239.60                           |
| `mail.benkner-it.com` | AAAA | 2a01:04f8:c012:8036:0000:0000:0000:0001  |

## CNAME Records

| Hostname                      | Type   | Value               |
|-------------------------------|--------|---------------------|
| `mta-sts.benkner-it.com`      | CNAME  | mail.benkner-it.com |
| `autoconfig.benkner-it.com`   | CNAME  | mail.benkner-it.com |
| `autodiscover.benkner-it.com` | CNAME  | mail.benkner-it.com |

## MX Record

| Domain            | Type | Value               |
|-------------------|------|---------------------|
| `benkner-it.com`  | MX   | mail.benkner-it.com |

## SRV Records

| Service                              | Type | Priority | Port | Target              |
|--------------------------------------|------|----------|------|---------------------|
| `_caldavs._tcp.benkner-it.com`       | SRV  | 1        | 443  | mail.benkner-it.com |
| `_carddavs._tcp.benkner-it.com`      | SRV  | 1        | 443  | mail.benkner-it.com |
| `_imaps._tcp.benkner-it.com`         | SRV  | 1        | 993  | mail.benkner-it.com |
| `_jmap._tcp.benkner-it.com`          | SRV  | 1        | 443  | mail.benkner-it.com |
| `_submission._tcp.benkner-it.com`    | SRV  | 1        | 587  | mail.benkner-it.com |
| `_autodiscover._tcp.benkner-it.com`  | SRV  | 0        | 443  | mail.benkner-it.com |
