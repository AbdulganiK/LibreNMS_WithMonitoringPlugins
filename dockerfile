FROM librenms/librenms:latest

# während des Builds als root arbeiten
USER root

# --- Pakete installieren (Alpine ODER Debian/Ubuntu) ---
RUN set -eux; \
  if command -v apk >/dev/null 2>&1; then \
    apk add --no-cache \
      monitoring-plugins \
      monitoring-plugins-extra \
      nrpe \
      ipmitool net-snmp-tools bind-tools \
      curl wget procps iproute2 iputils coreutils \
      nano vim less htop net-tools; \
  else \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      monitoring-plugins \
      nagios-plugins \
      nagios-plugins-extra \
      nagios-nrpe-plugin \
      ipmitool snmp dnsutils \
      curl wget procps iproute2 iputils-ping \
      nano vim less htop net-tools; \
    rm -rf /var/lib/apt/lists/*; \
  fi

# --- Start-Hook: Plugin-Pfad erkennen & in LibreNMS setzen ---
# legt /etc/cont-init.d/10-nagios-plugins.sh an (s6-overlay führt das beim Start aus)
RUN printf '%s\n' '#!/usr/bin/env bash' \
  'set -euo pipefail' \
  '' \
  '# Pfad der Plugins automatisch ermitteln' \
  'PLUGIN_DIR=""' \
  'for d in /usr/lib/monitoring-plugins /usr/lib/nagios/plugins /usr/lib64/nagios/plugins; do' \
  '  if [ -d "$d" ] && ls "$d"/check_* >/dev/null 2>&1; then PLUGIN_DIR="$d"; break; fi' \
  'done' \
  '' \
  'if [ -z "${PLUGIN_DIR}" ]; then' \
  '  echo "Keine Nagios/Monitoring-Plugins gefunden!" >&2' \
  '  exit 1' \
  'fi' \
  '' \
  '# LibreNMS-Config setzen (als librenms-User)' \
  'su -s /bin/sh -c "php /opt/librenms/lnms config:set show_services 1" librenms' \
  "su -s /bin/sh -c \"php /opt/librenms/lnms config:set nagios_plugins '\$PLUGIN_DIR'\" librenms" \
  '' \
  '# sanity check: ein Plugin einmalig testen' \
  'if [ -x "$PLUGIN_DIR/check_http" ]; then "$PLUGIN_DIR/check_http" -H example.org || true; fi' \
  > /etc/cont-init.d/10-nagios-plugins.sh && \
  chmod +x /etc/cont-init.d/10-nagios-plugins.sh

# (Optional) Falls du eigene Scripts in cont-init.d mountest, sicherstellen, dass sie ausführbar sind
RUN chmod +x /etc/cont-init.d/* || true

# zurück zum Standard-User
USER librenms
