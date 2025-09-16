FROM librenms/librenms:latest

# Nagios/Monitoring-Plugins installieren (Alpine)
RUN apk add --no-cache monitoring-plugins

# NRPE client (provides check_nrpe, so LibreNMS can query NSClient++ on Windows)
RUN apk add --no-cache nrpe

# Nützliche Tools fürs Troubleshooting / Admin
RUN apk add --no-cache \
    nano \
    vim \
    less \
    procps \
    iproute2 \
    curl \
    wget \
    htop \
    net-tools

# (optional: IPMI, SNMP, DNS-Tools)
RUN apk add --no-cache ipmitool net-snmp-tools bind-tools

# Script ausführbar machen (wird per Volume eingebunden, aber wir setzen hier ein Fallback)
RUN chmod +x /etc/cont-init.d/* || true
