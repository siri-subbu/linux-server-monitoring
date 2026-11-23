#!/bin/bash
LOG="$HOME/linux-monitor/monitor.log"
DISK_LIMIT=80
MEM_LIMIT=80
SERVICES=("nginx" "ssh")

log(){ echo "$(date '+%Y-%m-%d %H:%M:%S') [$1] $2" >> "$LOG";}

disk=$(df / | awk 'NR==2 {gsub("%","",$5); print $5}')
mem=$(free | awk '/Mem:/ {printf "%d", $3/$2*100}')

if [ "$disk" -ge "$DISK_LIMIT" ]; then log ALERT "Disk usage ${disk}%"; else log OK "Disk usage ${disk}%";fi
if [ "$mem" -ge "$MEM_LIMIT" ]; then log ALERT "Memory usage ${mem}%"; else log OK "Memory usage ${disk}%";fi

for svc in "${SERVICES[@]}";do
	if systemctl is-active --quiet "$svc"; then 
		log OK "$svc is running"
	else 
		log ALERT "$svc is DOWN"
	fi
done

