# 🎯 MITRE ATT&CK Enterprise Matrix Mapping & Defensive Coverage

Tài liệu này tổng hợp toàn bộ năng lực phát hiện (Detection) và phản ứng tự động hóa (Response) của phòng Lab theo chuẩn khung ma trận **MITRE ATT&CK Enterprise Matrix**. Việc ánh xạ này giúp đội ngũ SecOps và ban lãnh đạo đánh giá được độ phủ phòng thủ (Defensive Coverage), các khoảng trống bảo mật (Security Blindspots), và các biện pháp bù đắp (Compensating Controls).

---

## 📊 Bảng Ma Trận Ánh Xạ Toàn Diện (MITRE ATT&CK Coverage Matrix)

| Chiến Thuật (Tactic) | Kỹ Thuật (Technique) | Mã MITRE | Nguồn Dữ Liệu (Data Source) | Luật Phát Hiện SIEM | Phản Ứng SOAR Tự Động Hóa | Minh Chứng Thực Nghiệm | Đánh Giá Rủi Ro Tồn Đọng |
| :--- | :--- | :---: | :--- | :---: | :--- | :---: | :--- |
| **Reconnaissance** | Active Scanning: Port Scan | `T1595.001` | Snort NIDS 2.9 (`local.rules`) | Rule 100002 (Level 12) | Đối soát VirusTotal CTI + Tạo ticket Jira + 1-Click IPTables Block | Ping Kali rớt gói 100% | Kẻ tấn công đổi địa chỉ IP hoặc chuyển sang quét phân tán từ nhiều nguồn (Distributed Port Scan). |
| **Discovery** | Network Service Discovery | `T1046` | Network Traffic Flow (Snort fast log) | Rule 100002 (Level 12) | Dynamic IPTables Isolation (`firewall-drop.sh`) | 0 packets received | Quét chậm (Slow scan) dưới ngưỡng phát hiện của Snort thresholding. |
| **Credential Access** | OS Credential Dumping: LSASS Memory | `T1003.001` | Sysmon Event ID 10 (`TargetImage: lsass.exe`) | Rule 100200 (Level 12) | Thẩm định quyền truy cập bộ nhớ (`0x1fffff` vs `0x1410`) + Kích hoạt AI Copilot | Jira Ticket SA-76 & SA-77 (True vs False Positive) | Attacker chuyển sang dump LSASS bằng kỹ thuật gián tiếp (như Comsvcs.dll hoặc thủ thuật handle mirroring). |
| **Execution** | User Execution: Malicious File | `T1204.002` | Wazuh FIM Realtime (`Downloads\` folder) | Rule 100055 (Level 10) | Truy vấn VirusTotal SHA256 + Bộ lọc Gatekeeper + 1-Click File Quarantine | File `lesson29.exe` biến mất khỏi Windows Explorer | Mã độc chưa có chữ ký trên VirusTotal (Zero-day payload) lọt qua bộ lọc CTI. |
| **Execution** | Command and Scripting Interpreter: PowerShell | `T1059.001` | Sysmon Event ID 1 / Windows Security Event 4688 | Rule 100200 (Correlated) | Trích xuất command-line telemetry và đưa vào khối CodeBlock YAML | Jira PANE 2 Telemetry Dump | PowerShell Obfuscation hoặc chạy mã nhúng trực tiếp trong bộ nhớ (In-Memory execution). |
| **Defense Evasion** | Indicator Removal on Host: File Deletion | `T1070.004` | Wazuh Active Response API | Active Response `remove-threat0` | Tự động hóa gọi lệnh xóa mã độc bảo vệ nạn nhân | Thư mục Downloads sạch bóng payload | File đã kịp thực thi và nhân bản sang thư mục ẩn danh trước khi bị xóa. |

---

## 🛡️ Phân Tích Chiến Lược Phòng Thủ Đa Lớp (Defense-in-Depth Strategy)

### 1. Phễu Lọc Tự Động Hóa (SOAR Noise Gatekeeper)
* **Vấn đề của SOC truyền thống:** Mọi cảnh báo phát hiện file mới từ FIM đều tạo ticket làm tràn ngập bảng điều khiển của Tier 1 Analyst (Alert Fatigue).
* **Giải pháp trong Lab:** Shuffle SOAR hoạt động như một "người gác cổng" thông minh. Chỉ khi VirusTotal trả về `malicious > 0`, luồng xử lý mới phân nhánh tạo ticket. Khi người dùng tải phần mềm an toàn như HWiNFO64 (`malicious = 0`), quy trình dừng tại chỗ, triệt tiêu 100% ticket rác.

### 2. Mô Hình Con Người Kiểm Soát (Human-in-the-Loop - HitL)
* **Vấn đề của tự động hóa mù quáng (Blind Automation):** Tự động ngắt kết nối mạng hoặc tắt tiến trình trên các máy chủ Domain Controller hoặc Core Gateway có thể gây sập toàn bộ dịch vụ kinh doanh.
* **Giải pháp trong Lab:** Toàn bộ các hành động phản ứng phá hủy (Drop IP, Delete File) đều yêu cầu sự phê duyệt 1-Click của Analyst trên Jira sau khi đã được AI Copilot hỗ trợ thẩm định đầy đủ.

### 3. Phân Biệt True Positive và False Positive Theo Ngữ Cảnh
* **Quyền `0x1fffff` (Full Access):** Đặc trưng của hành vi tấn công trích xuất dữ liệu nhạy cảm (Atomic Red Team ProcDump).
* **Quyền `0x1410` (Query Limited Information):** Đặc trưng của tiến trình quản trị và giám sát hợp lệ (Wazuh Agent Syscollector).
* **Hệ quả:** Tránh được việc cô lập nhầm hệ thống hoặc báo động giả trong các đợt rà quét định kỳ của phần mềm diệt virus.
