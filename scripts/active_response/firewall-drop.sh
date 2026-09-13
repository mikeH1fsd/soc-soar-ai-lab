#!/bin/bash
# Wazuh Active Response Wrapper: Dynamic IPTables Block (Linux)
# Location on Agent: /var/ossec/active-response/bin/firewall-drop

ACTION=$1
USER=$2
IP=$3

if [ "$ACTION" = "add" ]; then
    iptables -I INPUT -s "$IP" -j DROP
    iptables -I FORWARD -s "$IP" -j DROP
    echo "[$(date)] Blocked attacker IP $IP" >> /var/ossec/logs/active-responses.log
elif [ "$ACTION" = "delete" ]; then
    iptables -D INPUT -s "$IP" -j DROP
    iptables -D FORWARD -s "$IP" -j DROP
    echo "[$(date)] Unblocked IP $IP" >> /var/ossec/logs/active-responses.log
fi
exit 0
