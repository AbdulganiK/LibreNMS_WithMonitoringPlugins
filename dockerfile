FROM librenms/librenms:latest

# als root installieren
USER root

# Alpine: Monitoring-Plugins + NRPE-Client (check_nrpe)
RUN set -eux; \
    apk add --no-cache \
      monitoring-plugins \
      nrpe-plugin \
      nrpe \
      ipmitool net-snmp-tools bind-tools \
      curl wget procps iproute2 iputils coreutils \
      nano vim less htop net-tools

# Start-Hook: Plugin-Pfad erkennen und in LibreNMS setzen
RUN printf '%s\n' '#!/usr/bin/env bash' \
  'set -euo pipefail' \
  'PLUGIN_DIR=""' \
  'for d in /usr/lib/monitoring-plugins /usr/lib/nagios/plugins /usr/lib64/nagios/plugins; do' \
  '  if [ -d "$d" ] && ls "$d"/check_* >/dev/null 2>&1; then PLUGIN_DIR="$d"; break; fi' \
  'done' \
  'if [ -z "$PLUGIN_DIR" ]; then echo "Keine Nagios/Monitoring-Plugins gefunden!" >&2; exit 1; fi' \
  'su -s /bin/sh -c "php /opt/librenms/lnms config:set show_services 1" librenms' \
  "su -s /bin/sh -c \"php /opt/librenms/lnms config:set nagios_plugins '\$PLUGIN_DIR'\" librenms" \
  'if [ -x "$PLUGIN_DIR/check_http" ]; then "$PLUGIN_DIR/check_http" -H example.org || true; fi' \
  > /etc/cont-init.d/10-nagios-plugins.sh && \
  chmod +x /etc/cont-init.d/10-nagios-plugins.sh

# falls eigene cont-init.d-Skripte gemountet werden
RUN chmod +x /etc/cont-init.d/* || true

# zurück zum Standard-User
USER librenms
