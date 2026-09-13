#!/bin/bash
# ==============================================================================
# Attack Simulation: Nmap Stealth SYN Port Scan (MITRE ATT&CK T1595.001 / T1046)
# Target: Ubuntu Web Server (192.168.109.161)
# ==============================================================================

TARGET_IP="192.168.109.161"
PORTS="21,22,80,443,3306,8080"

echo "=================================================================="
echo "[+] Starting Nmap Stealth SYN Scan against target: $TARGET_IP"
echo "[+] Target ports: $PORTS"
echo "[+] This will trigger Snort Rule 1000005 & Wazuh SIEM Rule 100002"
echo "=================================================================="

# Test reachability before attack
echo "[*] Step 1: Testing initial network reachability via ICMP..."
ping -c 3 "$TARGET_IP"

# Run aggressive stealth SYN scan with timing template -T4
echo "[*] Step 2: Firing Nmap SYN scan..."
nmap -sS -p "$PORTS" -T4 "$TARGET_IP"

echo "[*] Step 3: Verifying active response containment..."
echo "[*] If SOAR 1-Click Block was approved, ping should show 100% packet loss:"
ping -c 5 "$TARGET_IP"

echo "=================================================================="
echo "[✓] Simulation finished. Check Jira Board for generated incident ticket."
echo "=================================================================="
