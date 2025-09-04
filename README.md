# LibreNMS with Monitoring Plugins (Nagios)

This repository provides a customized Docker setup for **LibreNMS**, extended with **Nagios/Monitoring Plugins**.  
With these plugins, LibreNMS can perform additional service checks (HTTP, Ping, TCP, etc.) directly from the web interface.

---

## Installation

- Clone the repository  
  ```bash
  git clone https://github.com/AbdulganiK/LibreNMS_WithMonitoringPlugins.git
  cd LibreNMS_WithMonitoringPlugins

- Create and edit environment files
  ```bash
  cp librenms.env.example librenms.env
  cp msmtpd.env.example msmtpd.env
  nano librenms.env
  nano .env

- Build and start the containers
    ```bash
    docker compose build
    docker compose up -d

