# 🛡️ Enterprise Automated SOC & AI-Powered Incident Response Platform (SOAR Lab)

[![Wazuh](https://img.shields.io/badge/SIEM-Wazuh%20v4.x-blue?style=for-the-badge&logo=wazuh)](https://wazuh.com/)
[![Shuffle SOAR](https://img.shields.io/badge/SOAR-Shuffle-orange?style=for-the-badge)](https://shuffler.io/)
[![Jira Cloud](https://img.shields.io/badge/ITSM-Jira%20Cloud%20REST%20API%20v3-0052CC?style=for-the-badge&logo=jira)](https://www.atlassian.com/software/jira)
[![Google Gemini](https://img.shields.io/badge/AI%20Copilot-Google%20Gemini%20Flash-8E75C2?style=for-the-badge&logo=googlegemini)](https://ai.google.dev/)
[![Snort](https://img.shields.io/badge/NIDS-Snort%202.9-red?style=for-the-badge)](https://www.snort.org/)
[![MITRE ATT&CK](https://img.shields.io/badge/Framework-MITRE%20ATT%26CK-black?style=for-the-badge)](https://attack.mitre.org/)

---

## 📌 Executive Summary

Traditional Security Operations Centers (SOCs) face two critical challenges:
1. **Alert Fatigue:** Tier 1 analysts are overwhelmed by thousands of disconnected alerts daily.
2. **The "Blast Radius" of Unchecked Automation:** Fully autonomous response scripts (e.g., auto-quarantining critical servers or auto-blocking internal IP addresses) can cause severe production outages.

This project implements an **Enterprise-grade, Human-in-the-Loop (HitL) Security Orchestration, Automation, and Response (SOAR) ecosystem**. By interconnecting **Wazuh SIEM**, **Snort NIDS**, **Shuffle SOAR**, **Atlassian Jira Cloud**, and **Google Gemini LLM**, this lab demonstrates how modern SecOps teams can automate triage, enrich alerts with Cyber Threat Intelligence (CTI), generate structured incident tickets, and empower analysts to trigger verified remediation with 1-click authorization.

---

## 🏛️ End-to-End System Architecture

```mermaid
flowchart TD
    subgraph Detection["🔍 Telemetry & Detection Layer"]
        A1["🖥️ Windows Endpoint<br/>(Sysmon + Wazuh FIM)"]
        A2["🐧 Ubuntu Web Server<br/>(Snort IDS + Wazuh Agent)"]
    end

    subgraph SIEM["🛡️ SIEM Core"]
        W1["Wazuh Manager<br/>(Correlation Rules 100055 & 100002)"]
    end

    subgraph SOAR["🔀 Automation & Orchestration (Shuffle)"]
        S1["Shuffle Webhooks"]
        S2["Python Sanitization & Data Normalization"]
        S3["VirusTotal CTI Enrichment"]
    end

    subgraph AI["🧠 Generative AI Triage"]
        G1["Google Gemini LLM<br/>(Zero-Hallucination SOC Prompt)"]
    end

    subgraph ITSM["🎫 Human-in-the-Loop Interface (Jira Cloud)"]
        J1["2-Pane Incident Ticket<br/>(Summary + Raw Telemetry)"]
        J2["Interactive Buttons:<br/>⚡ [1-Click Remediation]<br/>🤖 [On-Demand AI Triage]"]
        J3["Color-Coded ADF Callout Panel<br/>(Verdict, MITRE, Remediation)"]
    end

    subgraph Response["⚡ Active Response & Containment"]
        R1["Wazuh Active Response<br/>(PowerShell File Deletion)"]
        R2["Wazuh Active Response<br/>(Dynamic IPTables Firewall Drop)"]
    end

    A1 -->|Syscheck / File Drop| W1
    A2 -->|Nmap SYN Scan Alert| W1
    W1 -->|JSON Webhook| S1
    S1 --> S3
    S3 --> S2
    S2 -->|Atlassian ADF v3| J1
    J1 --> J2
    J2 -->|Trigger AI Analysis| G1
    G1 -->|Structured JSON| J3
    J2 -->|Authorize Containment| S1
    S1 -->|REST API PUT| W1
    W1 -->|remove-threat0| R1
    W1 -->|!firewall-drop| R2
```

---

## 🚀 Key Incident Response Playbooks

### Playbook 1: Endpoint Malware Detection & Containment
* **Attack Scenario:** A malicious executable (`eicar.com` / `mimikatz.exe`) is downloaded to `C:\Users\Public\Downloads`.
* **Detection:** Wazuh File Integrity Monitoring (FIM) detects file creation (Rule `100055`, Level 12).
* **SOAR Workflow:**
  1. Wazuh forwards alert to Shuffle via Webhook.
  2. Shuffle queries **VirusTotal API** for file reputation.
  3. Formats alert into an **Atlassian Document Format (ADF) 2-Pane Incident Ticket**:
     - **Pane 1:** High-level summary, host context, and remediation action banner.
     - **Pane 2:** Comprehensive technical telemetry dump for deep analysis.
  4. Analyst clicks **⚡ [☢️ APPROVE MALWARE DELETION]**.
  5. Shuffle invokes Wazuh REST API (`remove-threat0`), which executes a native PowerShell script on Windows to remove the malicious binary.
  6. Automated confirmation comment is posted back to Jira.

---

### Playbook 2: Network Reconnaissance & Dynamic Firewalling
* **Attack Scenario:** Attacker machine (Kali Linux) executes an aggressive stealth SYN port scan (`nmap -sS -p 1-1000 --min-rate 1000`) against the web server.
* **Detection:** **Snort IDS** detects threshold-breaking SYN packets without ACK (`local.rules`, SID `1000005`). Wazuh Agent captures log and triggers Rule `100002` (Level 12).
* **SOAR Workflow:**
  1. Shuffle extracts Attacker IP (`192.168.109.165`) and target telemetry.
  2. Jira ticket is automatically populated with packet details and MITRE mapping (`T1595.002`).
  3. SOC Analyst reviews alert and authorizes blocking via Jira manual trigger.
  4. Shuffle calls Wazuh REST API with `command: !firewall-drop`.
  5. Wazuh Agent dynamically inserts `iptables -I INPUT -s <Attacker_IP> -j DROP`.
  6. Subsequent attacker probes are completely dropped (`100% packet loss`).

---

### Playbook 3: On-Demand AI Incident Triage Copilot (Google Gemini)
* **Problem:** In complex alerts, junior analysts may struggle to correlate packet flags, MITRE techniques, and attack intent in under 60 seconds.
* **Solution:** An **interactive AI Copilot** embedded directly into Jira:
  1. Analyst clicks **`🤖 Hỏi AI SOC`** directly on any Jira alert ticket.
  2. Jira Automation dispatches ticket summary and raw telemetry to Shuffle.
  3. **Zero-Hallucination Prompting Engine:** The Python node wraps telemetry into an 8-rule strict prompt (banning fabricated IOCs, forcing evidence-based reasoning, and bounding intent strictly to observed data).
  4. **Google Gemini Flash** analyzes telemetry and outputs strict JSON:
     - `verdict`: `TRUE_POSITIVE` | `FALSE_POSITIVE` | `SUSPICIOUS`
     - `verdict_reasoning`: Technical justification based on TCP flags/ports.
     - `mitre_technique`: Verified MITRE technique ID and name.
     - `attacker_intent`: Probable objective and next staging step.
     - `remediation_actions`: 3-4 prioritized response actions.
  5. Shuffle converts JSON into an Atlassian ADF Callout Panel (Color-coded: 🔴 **Error/Red** for Critical/High, 🟡 **Warning/Yellow** for Suspicious, 🟢 **Success/Green** for False Positive) and posts it as an incident comment in **under 3 seconds**.

---

## 📸 Proof of Work & Verification

| Component | Screenshot & Description |
| :--- | :--- |
| **Interactive AI Triage in Jira** | ![AI SOC Triage](docs/pb3_ai_soc_triage.png)<br/>*Rich ADF Callout Panel automatically generated by Google Gemini inside Jira Ticket.* |
| **2-Pane Jira Ticket Architecture** | *Pane 1 (Actionable metadata & 1-click button) + Pane 2 (Full technical log telemetry).* |
| **Active Response Verification** | *Linux `iptables -L -n` showing attacker IP in `DROP` chain with 100% packet drop.* |

---

## 🛠️ Repository Organization

```text
soc-soar-ai-lab/
├── README.md                          # Project documentation and architectural overview
├── docs/                              # Screenshots and visual proof of work
│   └── pb3_ai_soc_triage.png          # Live Jira AI Triage comment screenshot
├── configs/                           # Detection & SIEM configuration files
│   ├── wazuh/                         # Custom Wazuh rules & integration hooks
│   │   ├── local_rules.xml
│   │   └── ossec_integration.xml
│   ├── snort/                         # Snort NIDS detection rules
│   │   └── local.rules
│   └── sysmon/                        # Windows Sysmon configuration
│       └── sysmonconfig.xml
├── scripts/                           # Host-based Active Response scripts
│   ├── active_response/
│   │   ├── remove-threat.cmd          # Windows PowerShell file deletion wrapper
│   │   └── firewall-drop.sh           # Linux IPTables dynamic rule insertion
│   └── helpers/
│       └── gemini_prompt_builder.py   # Python string escaping & JSON sanitization
└── prompts/                           # System prompts for Generative AI
    └── soc_analyst_l3_prompt.md       # 8-Rule Zero-Hallucination Prompt Framework
```

---

## 🧠 Key Technical Challenges Solved

1. **Jira Cloud REST API v3 ADF Conformance:**
   - Jira Cloud v3 rejects plain-text strings in comments and descriptions, requiring deep Atlassian Document Format (`type: "doc"`). Solved by building an automated ADF JSON builder in Python handling nested panels, marks, and bullet lists.
2. **Preventing LLM Prompt Injection & JSON Breaking:**
   - Raw IDS and system logs contain unescaped double quotes, backslashes, and arbitrary newlines that easily break downstream HTTP payloads. Solved with a dedicated regex sanitizer (`.replace('\', '\\').replace('"', "'").replace('
', '\n')`).
3. **HTTP 406 Not Acceptable & Content Negotiation:**
   - Overcame Atlassian v3 gateway rejections by strictly enforcing `Accept: application/json` and `Content-Type: application/json` headers within SOAR HTTP modules.
4. **Snort Alert Cooldown & Threshold Tuning:**
   - Tuned Snort rule thresholds (`count 100, seconds 5`) to eliminate false-negative suppression windows while maintaining high-fidelity detection of Nmap stealth scans.

---

## 👨‍💻 Author & Contact

* **Role:** SOC Analyst / Security Automation Engineer
* **Core Skills:** SIEM/SOAR Architecture, Detection Engineering, Incident Response, Python Automation, Generative AI for SecOps.
