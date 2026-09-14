# 🔀 Shuffle SOAR Production Workflow Templates

This directory contains the complete collection of production-grade SOAR workflow definitions (JSON schemas) verified and executed within this SOC Automation Lab. Security engineers and hiring managers can import these templates directly into **Shuffle SOAR** (Cloud or self-hosted Docker) to reproduce 100% of the incident response playbooks.

---

## 📂 Catalog of SOAR Automated Workflows

| # | Workflow File | Description & Capability | Ingestion Trigger | Integrated Apps |
| :---: | :--- | :--- | :--- | :--- |
| **01** | [`workflow_lsass_dump_detection.json`](workflow_lsass_dump_detection.json) | **Playbook 1: LSASS Memory Access Ingestion.** Ingests Sysmon Event ID 10 alerts from Wazuh Manager (Rule 100200), normalizes process IDs, access masks, and call stack traces via Python, and creates a high-priority 2-Pane Jira incident ticket. | Webhook from Wazuh Manager (`Rule 100200`) | Wazuh, Shuffle Tools (Python), Jira Cloud v3 |
| **02** | [`workflow_gemini_ai_soc_triage.json`](workflow_gemini_ai_soc_triage.json) | **Playbook 1, 2, 3: On-Demand AI SOC Triage Copilot.** Extracts telemetry from Jira issues, evaluates events against the L3 SOC anti-hallucination prompt using Google Gemini API, and renders structured, color-coded ADF Callout Panels (Red for True Positive, Green for False Positive) in Jira comments. | Webhook from Jira Automation (`AI_support`) | Jira Cloud v3, Google Gemini API, Shuffle Tools |
| **03** | [`workflow_nmap_recon_detection.json`](workflow_nmap_recon_detection.json) | **Playbook 2: Nmap Reconnaissance Ingestion.** Receives Snort SYN scan detections from Wazuh Manager (Rule 100002), queries VirusTotal v3 for attacker IP threat score, formats 2-Pane ADF payload, and auto-generates Jira Incident Ticket SA-72. | Webhook from Wazuh Manager (`Rule 100002`) | Wazuh, VirusTotal v3, Shuffle Tools, Jira Cloud v3 |
| **04** | [`workflow_nmap_firewall_block_ip.json`](workflow_nmap_firewall_block_ip.json) | **Playbook 2: Network Containment (IPTables Block).** Receives 1-click authorization from Jira (`block ip`), acquires JWT authentication from Wazuh API, issues Active Response command `!firewall-drop` to inject dynamic IPTables block, and reports status to Jira. | Webhook from Jira Automation (`block ip`) | Jira Cloud v3, Shuffle Tools, Wazuh REST API (`firewall-drop`) |
| **05** | [`workflow_fim_malware_detection.json`](workflow_fim_malware_detection.json) | **Playbook 3: Real-time FIM & CTI Gatekeeper.** Monitors Windows file additions via Wazuh FIM (Rule 100055), queries VirusTotal v3 for SHA256 file hash reputation, and enforces condition filtering: halts on benign files (`malicious == 0`, zero alert spam) or creates Jira Ticket SA-79 for confirmed threats. | Webhook from Wazuh FIM (`Rule 100055`) | Wazuh FIM, VirusTotal v3, Shuffle Condition Node, Jira Cloud v3 |
| **06** | [`workflow_fim_active_response_delete_file.json`](workflow_fim_active_response_delete_file.json) | **Playbook 3: Host File Eradication.** Receives 1-click authorization from Jira (`delete_window_file_to_shuffle`), extracts target Windows path, acquires Wazuh API JWT token, invokes Active Response command `remove-threat0` on Agent 003, and posts eradication proof to Jira. | Webhook from Jira Automation (`delete_window_file_to_shuffle`) | Jira Cloud v3, Shuffle Tools, Wazuh REST API (`remove-threat0`) |

---

## 🛠️ Step-by-Step Import Guide

1. **Access Shuffle SOAR**: Open the Shuffle Web Interface (`http://<SHUFFLE_IP>:3001` or Shuffler.io Cloud).
2. **Navigate to Workflows**: Go to the **Workflows** tab and click **Import Workflow**.
3. **Upload Schema**: Select the desired `.json` file from this directory (e.g., `workflow_fim_malware_detection.json`).
4. **Configure Secrets & Credentials**:
   * **VirusTotal App**: Supply your VirusTotal API Key in the Authentication settings of the `Virustotal_v3` node.
   * **Jira Cloud App**: Enter your Jira Cloud URL (`https://your-domain.atlassian.net`), registered account email, and Jira API Token.
   * **Wazuh API**: Provide the Wazuh API credentials (`wazuh-wui` or dedicated API user) in the `Get_Token` HTTP node to obtain valid JWT Bearer tokens.
   * **Google Gemini API**: Provide your Google Gemini API Key in the `post_generate_content_with_flash` node.
5. **Activate**: Toggle the workflow status to **Active / Running** and configure your Wazuh or Jira webhooks to target the generated webhook URI.
