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
        S2["Python Normalization & ADF Packaging"]
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

    A1 -->|File Drop Alert| W1
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

## 🚀 Incident Response Playbooks (Documentation Hub)

This repository adopts a modular **Hub & Spoke** documentation architecture. Click on each playbook card below to read the comprehensive technical case study, step-by-step screenshots, and evidence trails:

| Playbook | Threat Vector & Scope | Technology Stack | Detailed Case Study |
| :--- | :--- | :--- | :---: |
| **Playbook 1: OS Credential Dumping & AI SOC Triage** | In-memory LSASS extraction via Sysinternals ProcDump (Atomic Red Team T1003.001). Sysmon Event ID 10 detection (`0x1fffff`), Level 12 SIEM correlation, automated 2-Pane Jira ticketing, and Google Gemini AI incident triage. | Atomic Red Team, Sysmon, Wazuh SIEM, Shuffle SOAR, Jira Cloud, Google Gemini | 👉 **[📖 Read Case Study (14 Screenshots: TP vs FP)](docs/playbooks/playbook_1_lsass_dump_defense.md)** |
| **Playbook 2: Network Reconnaissance Defense** | Aggressive stealth Nmap SYN scanning against production web server. Snort NIDS detection, Level 12 SIEM correlation, and dynamic IPTables isolation. | Snort 2.9, Wazuh SIEM, Shuffle SOAR, Jira Cloud, IPTables | 👉 **[📖 Read Case Study (11 Screenshots)](docs/playbooks/playbook_2_nmap_defense.md)** |
| **Playbook 3: Interactive AI SOC Triage Copilot** | On-demand LLM incident triage directly inside Jira. Zero-hallucination prompting, technical verdict reasoning, MITRE mapping, and color-coded ADF callout panels in < 3s. | Google Gemini Flash, Shuffle Python, Jira Cloud REST API v3 | 👉 **[📖 Read Case Study & Prompts](docs/playbooks/playbook_1_lsass_dump_defense.md#step-7-expert-ai-triage-verdict--remediation-guidance)** |

---

## 📸 Key Visual Proof of Work

| Interactive AI Triage (Google Gemini in Jira) | Containment Verification (100% Packet Loss) |
| :---: | :---: |
| ![AI SOC Triage](docs/images/07_gemini_ai_comment.png) | ![Containment Verification](docs/images/09_kali_ping_100_percent_loss.png) |
| *Structured ADF Callout Panel generated by Gemini in Jira.* | *Kali ICMP packets dropped: 60 sent, 0 received, 100% packet loss.* |

---

## 🛠️ Repository Organization

```text
soc-soar-ai-lab/
├── README.md                                  # Landing page & architectural overview (You are here)
├── docs/
│   ├── images/                                # High-resolution screenshots and proof-of-work
│   │   ├── 00_wazuh_before_no_alerts.png
│   │   ├── 02_nmap_scan_attack.png
│   │   ├── 05_jira_ticket_pane1.png
│   │   ├── 07_gemini_ai_comment.png
│   │   └── 09_kali_ping_100_percent_loss.png
│   └── playbooks/                             # Modular playbook documentation
│       ├── playbook_1_lsass_dump_defense.md   # Full case study: LSASS credential dumping & AI triage
│       └── playbook_2_nmap_defense.md         # Full case study: Nmap defense & dynamic firewalling
├── configs/                                   # Production-ready detection configurations
│   ├── wazuh/                                 # Custom correlation rules & webhook integrations
│   │   ├── local_rules.xml
│   │   └── ossec_integration.xml
│   ├── snort/                                 # Snort 2.9 thresholding rules
│   │   └── local.rules
│   └── sysmon/                                # Windows Sysmon event filtering
│       └── sysmonconfig.xml
├── scripts/                                   # Host-level Active Response & utility scripts
│   ├── active_response/
│   │   ├── remove-threat.cmd                  # Windows PowerShell file deletion wrapper
│   │   └── firewall-drop.sh                   # Linux IPTables dynamic isolation wrapper
│   └── helpers/
│       └── gemini_prompt_builder.py           # Python string escaping & JSON sanitization
└── prompts/                                   # Enterprise Generative AI prompts
    └── soc_analyst_l3_prompt.md               # 8-Rule Zero-Hallucination Prompt Framework
```

---

## 🧠 Key Technical Challenges Solved

1. **Jira Cloud REST API v3 ADF Conformance:**
   - Handled Atlassian's strict nested document schema (`type: "doc"`) for both incident tickets and rich color-coded comments without using brittle HTML.
2. **Preventing LLM Prompt Injection & JSON Breaking:**
   - Raw IDS and system logs contain unescaped double quotes, backslashes, and arbitrary newlines that easily break downstream HTTP payloads. Solved with a dedicated regex sanitizer (`.replace('\\', '\\\\').replace('"', "'").replace('\n', '\\n')`).
3. **HTTP 406 Not Acceptable & Content Negotiation:**
   - Overcame Atlassian v3 gateway rejections by strictly enforcing `Accept: application/json` and `Content-Type: application/json` headers within SOAR HTTP modules.
4. **Snort Alert Cooldown & Threshold Tuning:**
   - Tuned Snort rule thresholds (`count 100, seconds 5`) to eliminate false-negative suppression windows while maintaining high-fidelity detection of Nmap stealth scans.

---

## 👨‍💻 Author & Contact

* **Role:** SOC Analyst / Security Automation Engineer
* **Core Skills:** SIEM/SOAR Architecture, Detection Engineering, Incident Response, Python Automation, Generative AI for SecOps.
