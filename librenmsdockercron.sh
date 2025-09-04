# minütlich den Laravel-Scheduler ausführen
* * * * * php /opt/librenms/artisan schedule:run --no-ansi --no-interaction > /dev/null 2>&1

# (optional) weitere Standardjobs, falls du willst:
15 0 * * * cd /opt/librenms && bash daily.sh >> /opt/librenms/logs/daily.log 2>&1
