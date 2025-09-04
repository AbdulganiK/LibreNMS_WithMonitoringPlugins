FROM librenms/librenms:latest

# Nagios/Monitoring-Plugins installieren (Alpine)
RUN apk add --no-cache monitoring-plugins

# (optional, aber nützlich)
RUN apk add --no-cache ipmitool net-snmp-tools bind-tools
