# ONLYOFFICE Document Server Deployment via Ansible

This project automates the installation and configuration of [ONLYOFFICE Document Server](https://www.onlyoffice.com/) using Ansible. It includes support for HTTPS with TLS encryption using either a **custom certificate** or **Let's Encrypt** with **DNS-01 validation** via Cloudflare.

## 📁 Project Structure

```
.
├── README.md                   
├── docs
│   └── lets_encrypt_dns01.md  # Additional documentation
├── group_vars/
│   └── all.yaml                # Global variables
├── inventory/
│   └── hosts.ini               # Inventory file
├── playbooks/
│   └── main.yaml               # Main playbook
└── roles/
    └── install_onlyoffice/
        ├── defaults/
        │   └── main.yaml       # Default variable definitions
        ├── files/              # Static files used in setup
        │   ├── custom_bash.rc
        │   ├── custom_dns_verification_certbot.sh
        │   └── external_lb.conf
        ├── handlers/
        │   └── main.yaml
        └── tasks/
            ├── 00_prerequisites.yaml
            ├── 01_postgresql.yaml
            ├── 02_rabbitmq.yaml
            ├── 03_nginx_extras.yaml
            ├── 04_onlyoffice.yaml
            ├── 05_tls_own_cert.yaml
            ├── 06_tls_lets_encrypt.yaml
            └── main.yaml       # Includes all task files
```

By default, this playbook configures the `Nginx Web Server` on the host. If instead you want an external LB to handle the requests to OnlyOffice, an example of an NGINX configuration file for it can be found in `roles/install_onlyoffice/files/external_lb.conf`

## System Requirements
- **CPU:** Dual-core 2 GHz or better
- **RAM:** At least 2 GB
- **Disk Space:** Minimum 40 GB free
- **SWAP:** At least 4 GB

## ⚙️ Configuration Variables (`defaults/main.yaml`)

| Variable | Description | Example |
|---------|-------------|---------|
| `onlyoffice_domain` | Your ONLYOFFICE domain | `"office.example.com"` |
| `onlyoffice_ip` | IP of the server | `"127.0.0.1"` |
| `onlyoffice_db_host` | PostgreSQL host | `"127.0.0.1"` |
| `onlyoffice_db_user` | DB user for ONLYOFFICE | `"onlyoffice"` |
| `onlyoffice_db_password` | Password for DB user | `"onlyoffice"` |
| `onlyoffice_db_name` | Database name | `"onlyoffice"` |

### TLS Options

#### ✅ Custom TLS Certificates

| Variable | Description |
|---------|-------------|
| `tls_use_own_cert` | Enable using your own TLS certs (`true/false`) |
| `local_cert_chain_path` | Path to local `.crt` file |
| `local_cert_key_path` | Path to local `.key` file |
| `host_cert_chain_path` | Destination on server for `.crt` |
| `host_cert_key_path` | Destination on server for `.key` |

#### ✅ Let's Encrypt TLS (Default)

| Variable | Description |
|---------|-------------|
| `tls_with_lets_encrypt` | Enable Let's Encrypt support |
| `letsencrypt_email` | Email used for Let's Encrypt |
| `lets_encrypt_dns_verification` | Enable DNS-01 challenge |
| `cloudflare_api_token` | API token for DNS update via Cloudflare. Used only for DNS-01 challange |

> 🔐 **Note**: By default, Let's Encrypt is using HTTP-01 challange (requires an valid domain and your server to have an public reachable IP). DNS-01 is used when `lets_encrypt_dns_verification: true`. This is useful for private servers or internal IPs. For more info: `/docs/lets_encrypt_dns01.md`

## ❓ How to Use

1. **Update your inventory (`inventory/hosts.ini`)**
2. **Edit variables in `defaults/main.yaml`**
3. **Run the playbook:**
   ```bash
   ansible-playbook -i inventory/hosts.ini playbooks/main.yaml
   ```

## Useful Resources

For more information, please refer to the links in the official documentation:

📘 [Install Document Server on Ubuntu](https://helpcenter.onlyoffice.com/docs/installation/docs-community-install-ubuntu.aspx)

🌐 [Configure External NGINX Proxy](https://helpcenter.onlyoffice.com/docs/installation/docs-community-proxy.aspx)

🔐 [Configure HTTPS](https://helpcenter.onlyoffice.com/docs/installation/docs-community-https-linux.aspx)

---

## 📬 Contribution

For questions, suggestions, or improvements — feel free to open an issue or pull request.

---