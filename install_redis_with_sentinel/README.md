
# Install Redis Sentinel with Ansible

This Ansible playbook installs and configures Redis with Sentinel for automated failover and high availability.

## Installation

Follow these steps to install and configure Redis with Sentinel using Ansible.

The sentinels will be installed on the redis nodes.

### 1. Clone the repository

To get started, clone this repository to your local machine:

```bash
git clone https://github.com/SimonaCatanoiu/ansible-opensource-apps.git
cd intall_redis_with_sentinel
```

### 2. Modify the inventory file

Open the **`inventory/hosts.ini`** file and modify it to reflect the IP addresses of the servers where you want to install Redis and Sentinel.

Example inventory file:

```ini
[redis01]
redis01 ansible_host=<host_ip>

[redis02]
redis02 ansible_host=<host_ip>

[redis03]
redis03 ansible_host=<host_ip>

[redis:children]
redis01
redis02
redis03

[slaves:children]
redis02
redis03
```

### 3. Run the Ansible playbook

Once you have configured the inventory file, run the Ansible playbook to install and configure Redis with Sentinel:

```bash
ansible-playbook -i inventory/hosts.ini playbooks/main.yaml
```

This playbook will install and configure:

- **Redis** on the specified servers.
- **Redis Sentinel** for monitoring and failover of Redis instances.

### 4. Verify the installation

After the playbook has successfully run, check that the Redis and Redis Sentinel services are active and running:

```bash
redis-cli -h <redis_ip> ping
systemctl status redis-sentinel
```

Check the logs to ensure that Sentinel is monitoring the Redis instances:

```bash
tail -f /var/log/redis/redis-sentinel.log
```

## Repository Structure

```plaintext
.
├── inventory/
│   └── hosts.ini         # Ansible inventory file
├── playbooks/
│   └── main.yaml         # Main Ansible playbook
├── roles/
│   └── install_redis/             # Redis installation
│   └── configure_redis_sentinel/  # Redis & Sentinel configuration
└── README.md             # This file
```

