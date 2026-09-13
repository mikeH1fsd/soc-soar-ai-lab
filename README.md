# 🛡️ Enterprise Automated SOC & AI-Powered Incident Response Platform (SOAR Lab)

[![Wazuh](https://img.shields.io/badge/SIEM-Wazuh%20v4.x-blue?style=for-the-badge&logo=wazuh)](https://wazuh.com/)
[![Shuffle SOAR](https://img.shields.io/badge/SOAR-Shuffle%20Cloud-orange?style=for-the-badge)](https://shuffler.io/)
[![Jira Cloud](https://img.shields.io/badge/ITSM-Jira%20Cloud%20REST%20API%20v3-0052CC?style=for-the-badge&logo=jira)](https://www.atlassian.com/software/jira)
[![Google Gemini](https://img.shields.io/badge/AI%20Copilot-Google%20Gemini%20Flash-8E75C2?style=for-the-badge&logo=googlegemini)](https://ai.google.dev/)
[![Snort](https://img.shields.io/badge/NIDS-Snort%202.9-red?style=for-the-badge)](https://www.snort.org/)
[![MITRE ATT&CK](https://img.shields.io/badge/Framework-MITRE%20ATT%26CK-black?style=for-the-badge)](https://attack.mitre.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)

---

## 📌 Executive Summary

Traditional Security Operations Centers (SOCs) face two critical challenges:
1. **Alert Fatigue:** Tier 1 analysts are overwhelmed by thousands of disconnected alerts daily.
2. **The "Blast Radius" of Unchecked Automation:** Fully autonomous response scripts (e.g., auto-quarantining critical servers or auto-blocking internal IP addresses) can cause severe production outages.

This project implements an **Enterprise-grade, Human-in-the-Loop (HitL) Security Orchestration, Automation, and Response (SOAR) ecosystem**. By interconnecting **Wazuh SIEM**, **Snort NIDS**, **Shuffle SOAR Cloud**, **Atlassian Jira Cloud**, and **Google Gemini LLM**, this lab demonstrates how modern SecOps teams can automate triage, enrich alerts with Cyber Threat Intelligence (CTI), generate structured incident tickets, and empower analysts to trigger verified remediation with 1-click authorization.

---

## 🏛️ End-to-End System Architecture

```mermaid
flowchart TD
    subgraph Detection["🔍 Telemetry & Detection Layer"]
        A1["🖥️ Windows Endpoint<br/>(Sysmon + Wazuh FIM)"]
        A2["🐧 Ubuntu Linux Server<br/>(Snort IDS + Wazuh Agent)"]
    end

    subgraph SIEM["🛡️ SIEM Core"]
        W1["Wazuh Manager<br/>(Correlation Rules 100055, 100002 & 100200)"]
    end

    subgraph SOAR["🔀 Automation & Orchestration (Shuffle Cloud)"]
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
    W1 -->|Outbound Webhook| S1
    S1 --> S3
    S3 --> S2
    S2 -->|Atlassian ADF v3| J1
    J1 --> J2
    J2 -->|Trigger AI Analysis| G1
    G1 -->|Structured JSON| J3
    J2 -->|Authorize Containment| S1
    S1 -->|REST API PUT| W1
    W1 -->|remove-threat.cmd| R1
    W1 -->|!firewall-drop| R2
```

---

## 🖥️ Lab Environment & Network Schema

| Node / Thành phần | Môi trường / Nền tảng | Địa chỉ IP | Vai trò trong Lab |
| :--- | :--- | :---: | :--- |
| **Kali Linux** | Máy ảo (Attacker) | `192.168.109.165` | Máy tấn công: quét cổng Nmap, rà quét trinh sát mạng |
| **Ubuntu Server** | Máy ảo (SIEM / NIDS) | `192.168.109.161` | Máy chủ Wazuh Manager (All-in-One) + Snort NIDS bắt gói tin |
| **Windows 10** | Máy ảo (Endpoint) | `192.168.109.167` | Máy nạn nhân: cài Sysmon EID 10 và Wazuh Agent (FIM Realtime) |
| **Shuffle SOAR** | Cloud SaaS (`shuffler.io`) | Online | Nền tảng điều phối tự động hóa phản ứng sự cố (SOAR) |
| **Jira Cloud** | Cloud SaaS (`atlassian.net`) | Online | Hệ thống quản lý sự cố (ITSM) & giao diện duyệt phản ứng 1-Click |
| **Google Gemini & VT** | Cloud API | Online | Thẩm định sự cố AI mức L3 & tra cứu Cyber Threat Intelligence |

---

## 🚀 Incident Response Playbooks (Documentation Hub)

This repository adopts a modular **Hub & Spoke** documentation architecture. Click on each playbook card below to read the comprehensive technical case study, step-by-step screenshots, and evidence trails:

| Playbook | Threat Vector & Scope | Technology Stack | Detailed Case Study |
| :--- | :--- | :--- | :---: |
| **Playbook 1: OS Credential Dumping & AI Triage** | In-memory LSASS extraction via ProcDump (Atomic Red Team T1003.001). Sysmon Event ID 10 (`0x1fffff`), True Positive vs False Positive (`0x1410`) discrimination, and 6-step IR checklist. | Atomic Red Team, Sysmon, Wazuh SIEM, Shuffle SOAR, Jira Cloud, Google Gemini | 👉 **[📖 Read Case Study (14 Screenshots)](docs/playbooks/playbook_1_lsass_dump_defense.md)** |
| **Playbook 2: Network Reconnaissance Defense** | Aggressive stealth Nmap SYN scanning against Linux server (`192.168.109.161`). Snort NIDS detection, Level 12 SIEM correlation, 1-click authorization, and dynamic IPTables isolation (100% loss proof). | Snort 2.9, Wazuh SIEM, Shuffle SOAR, Jira Cloud, Linux IPTables | 👉 **[📖 Read Case Study (11 Screenshots)](docs/playbooks/playbook_2_nmap_defense.md)** |
| **Playbook 3: Endpoint Malware Containment (FIM)** | Real-time Trojan drop in Downloads (`lesson29.exe`). Wazuh FIM detection, VirusTotal CTI (30/71 engines), Google Gemini AI triage, and 1-click active response file deletion. | Wazuh Realtime FIM, VirusTotal API, Shuffle SOAR, Jira Cloud, Active Response | 👉 **[📖 Read Case Study (15 Screenshots: Attack vs Benign Gatekeeper)](docs/playbooks/playbook_3_malware_containment_fim.md)** |

---

## 📚 Technical Reference Guides & Engineering Artifacts

* 🔀 **[Shuffle SOAR Production Workflow Templates](playbooks/shuffle_workflows/README.md):** 5 ready-to-import JSON workflow files for Shuffle SOAR (Nmap Detection, Firewall Drop, FIM Malware, Active Response Delete, and Gemini AI Triage).
* 🎯 **[MITRE ATT&CK Matrix Mapping](docs/mitre_attack_matrix.md):** Comprehensive defensive coverage mapping across Reconnaissance, Credential Access, Execution, and Active Response.
* ⚔️ **[Attack Simulation Scripts](scripts/attack_simulation/):** Automated Bash, Batch, and PowerShell scripts to safely test and simulate attack telemetry across endpoints.

---

## 👨‍💻 Author & Contact

* **Role:** SOC Analyst / Security Automation Engineer
* **Core Skills:** SIEM/SOAR Architecture, Detection Engineering, Incident Response, Python Automation, Generative AI for SecOps.
