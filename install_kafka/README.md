# Kafka Installation via Ansible

📦 Automate the installation and configuration of Apache Kafka using Ansible, supporting both **Zookeeper** and **KRaft** (Kafka Raft Metadata mode).

## 📁 Project Structure

```
.
├── global-vars/
├── inventory/
│   └── hosts.ini                # Inventory file with host groups
├── playbooks/
│   └── main.yml                 # Main playbook
└── roles/
    └── install_kafka_role/
        ├── defaults/
        │   └── main.yml         # All variables are configured here
        ├── files/               # Static files (e.g., log4j)
        ├── handlers/
        ├── tasks/               # Logically separated tasks
        ├── templates/           # Jinja2 templates for configuration
        │   ├── kafka.kraft.server.properties.j2
        │   ├── kafka.server.properties.j2
        │   ├── kafka.service.j2
        │   ├── myid.j2
        │   ├── zookeeper.conf.j2
        │   └── zookeeper.service.j2
        └── vars/
```

## 🚀 Features

- Install Kafka in **Zookeeper** or **KRaft** mode
- Install Zookeeper
- Automatic data disk partitioning (optional)
- Full Kafka & Zookeeper configuration via centralized variables
- systemd services for Kafka and Zookeeper
- Custom logging via `log4j.properties`

## 🧰 Requirements

- **Ansible** 2.14+
- Supported OS: **Ubuntu**
- SSH access to the nodes
- Sudo privileges

## 🛠️ Configurable Variables (`defaults/main.yml`)

### 🕒 System Configuration

```yaml
timezone: "Europe/Bucharest"
java_version: 17
```

### 💽 Disk Configuration

```yaml
data_disks_devices:
  - vdb
disk_filesystem: xfs
```

### 🧠 Kafka Mode

```yaml
kafka_mode: kraft  # Options: kraft, zookeeper
```

### 🐘 Zookeeper

```yaml
zookeeper_version: 3.8.4
zookeeper_mirror: dlcdn.apache.org
zookeeper_user: zookeeper
zookeeper_group: zookeeper
zookeeper_client_port: 2181
zookeeper_conf_dir: /etc/zookeeper/conf
zookeeper_log_dir: /var/log/zookeeper
zookeeper_data_dir: /var/lib/zookeeper
zookeeper_maxClientCnxns: 50
zookeeper_tick_time: 2000
zookeeper_init_limit: 5
zookeeper_sync_limit: 2
zookeeper_autopurge_snap_retain_count: 3
zookeeper_autopurge_purge_interval: 24
```

### 🔁 Kafka KRaft Mode

```yaml
kafka_cluster_id: "e2c842ea-f118-451d-ad2e-374c606f5fc8"  # Optional
kafka_controller_port: 9093
```

### ☕ Kafka Broker

```yaml
kafka_version: 3.9.1
scala_version: 2.13
kafka_mirror: dlcdn.apache.org
kafka_user: kafka
kafka_group: kafka
kafka_conf_dir: /etc/kafka/config
kafka_log_dir: /var/log/kafka
kafka_home: /opt/kafka
kafka_port: 9092
kafka_heap_size: 4G
kafka_opts:
  - -XX:NewSize=256m
  - -XX:MaxGCPauseMillis=20
  - -XX:+UseG1GC
  - -XX:MetaspaceSize=96M 
  - -XX:G1HeapRegionSize=16M 
  - -XX:MinMetaspaceFreeRatio=50 
  - -XX:MaxMetaspaceFreeRatio=80
kafka_default_num_partitions: 1
kafka_transaction_state_log_replication_factor: 2
kafka_socket_send_buffer_bytes: 102400
kafka_socket_recieve_buffer_bytes: 102400
kafka_socket_request_max_bytes: 104857600
kafka_inter_broker_listener_name: PLAINTEXT
kafka_controller_listener_name: CONTROLLER
kafka_log_retention_hours: 168
kafka_log_retention_bytes: 0
kafka_log_segment_bytes: 1073741824
kafka_log_retention_check_interval_ms: 300000
kafka_num_network_threads: 3
kafka_num_io_threads: 8
kafka_log_flush_interval_messages: 10000
kafka_log_flush_interval_ms: 1000
kafka_log_cleaner_enable: false
kafka_zookeeper_connection_timeout_ms: 18000
kafka_num_recovery_threads_per_data_dir: 1
kafka_offsets_topic_num_partitions: 3
kafka_offsets_topic_replication_factor: 2
kafka_group_initial_rebalance_delay_ms: 0
kafka_transaction_state_log_min_isr: 2
```

## 📦 Installation

1. Clone the repository:

```bash
git clone https://github.com/<username>/<repository>.git
cd <repository>
```

2. Update `inventory/hosts.ini`:

### 🧪 Example `hosts.ini`

```ini
[kafka_nodes]
node1 ansible_host=<ip>
node2 ansible_host=<ip>
node3 ansible_host=<ip>

[kafka_masters]
node1
node2
node3

[kafka_brokers]
node1
node2
node3

[all:vars]
ansible_port=22
ansible_user=ubuntu
ansible_ssh_private_key_file=<path_to_private_key>
```

3. Run the playbook:

```bash
ansible-playbook -i inventory/hosts.ini playbooks/main.yml
```

For selective runs:

```bash
ansible-playbook -i inventory/hosts.ini playbooks/main.yml --tags kafka
```

## 📄 Contributions

🔧 For issues or contributions, open an Issue or a Pull Request.
