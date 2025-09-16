# LibreNMS with Monitoring Plugins (Nagios)

This repository provides a customized Docker setup for **LibreNMS**, extended with **Nagios/Monitoring Plugins**.  
With these plugins, LibreNMS can perform additional service checks (HTTP, Ping, TCP, etc.) directly from the web interface.

---

## Installation

- Clone the repository  
  ```bash
  git clone https://github.com/AbdulganiK/LibreNMS_WithMonitoringPlugins.git
  cd LibreNMS_WithMonitoringPlugins

- Copy and edit environment files
  ```bash
  cp librenms.env.example librenms.env
  cp msmtpd.env.example msmtpd.env
  nano librenms.env
  nano .env
  nano msmtpd.env

- Build and start the containers
    ```bash
    docker compose build
    docker compose up -d
- Login with Standard User Credentials. Not given exec into librenms container and add them with
  ```bash
  lnms user:add -p yourpassword -r admin yourusername
  
## Commands for Nagios
   ```bash
   echo '*/5 * * * * /opt/librenms/services-wrapper.py 1' > /etc/crontabs/librenms
   chown librenms:librenms /etc/crontabs/librenms
   chmod 600 /etc/crontabs/librenms

