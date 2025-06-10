# 📦 Nextcloud Deployment via Ansible

This project automates the installation and configuration of **Nextcloud** using **Ansible**. It's designed to set up a production-ready instance with NGINX/APACHE, PHP, Redis, MySQL/Postgres, TLS support, and a wide range of Nextcloud apps.

---

## 📁 Project Structure

```
.
├── README.md
├── global-vars
│   └── commons.yaml
├── inventory
│   └── hosts.ini
├── playbooks
│   └── main.yaml
└── roles
    └── install_nextcloud
        ├── defaults
        │   └── main.yml
        ├── files
        ├── handlers
        ├── tasks
        ├── templates
        └── vars
```

---

## ✅ Prerequisites

Install the required Ansible roles and collections:

```bash
ansible-galaxy install geerlingguy.php-versions
ansible-galaxy collection install nextcloud.admin
```

Ensure your target hosts are accessible via SSH and properly defined in the `inventory/hosts.ini`.

---

## ⚙️ How to Use

1. **Customize Variables**

   Modify the default variables in:

   - `roles/install_nextcloud/defaults/main.yml`
   - `global-vars/commons.yaml`

   Use **Ansible Vault** for sensitive information like:
   - `nextcloud_db_pwd`
   - `nextcloud_admin_pwd`
   - `nextcloud_mysql_root_pwd`

2. **Review Inventory**

   Define your hosts in `inventory/hosts.ini`.

3. **Run the Playbook**

   Execute the playbook:

   ```bash
   ansible-playbook -i inventory/hosts.ini playbooks/main.yaml
   ```

---

## 🧠 Features

- ✅ Full Nextcloud installation with all required components.
- 🔐 TLS certificate deployment.
- 💾 Custom data partition setup.
- 🚀 PHP 8.3 support with all required modules.
- 📦 Multiple Nextcloud apps installed.
- 🧠 Redis + MySQL/PostgreSql integration for performance.
- 📄 NGINX/Apache2 config templating via Jinja2.
- 🔁 Modular role-based design for easy customization.

---

## 🔐 Default Configuration Summary

### 🌐 Nextcloud

- **Trusted Domain(s)**: `my-nextcloud-test.mydom.com`, local IP
- **Trusted Proxie(s)**: IP of an external load balancer. An example of an NGINX configuration file for that external LB can be found in `roles/install_nextcloud/files/external_lb.conf`
- **Data Directory**: `/data`
- **Web Root**: `/opt/nextcloud`

### 🧠 PHP

- **Version**: `8.3`

### 🌐 NGINX/APACHE

- **TLS Support**: Enabled
- **Custom Certs**: Located in `roles/install_nextcloud/files/`

### 🔄 Redis

- **Unix Socket**: `/var/run/redis/redis.sock`

### 💾 Database

- **Backend**: MySQL or Postgresql

---

## 📌 Notes

- The setup includes custom Bash profile.
- Adjust mount device and partition info for the nextcloud data.
- Replace default passwords and use ansible vault to store them.

---

## 🙌 Credits

- Based on [ansible-collection-nextcloud-admin](https://github.com/nextcloud/ansible-collection-nextcloud-admin/tree/main)

---

## 🤝 Contributions

Issues, improvements, and pull requests are welcomed!
