# 🔀 Shuffle SOAR Production Workflow Templates

Thư mục này chứa toàn bộ các file JSON mã nguồn quy trình tự động hóa (SOAR Workflows) đã được kiểm chứng thực tế trong phòng Lab SOC Automation. Các kỹ sư hoặc nhà tuyển dụng có thể tải trực tiếp các file này và **Import 1-Click** vào hệ thống Shuffle SOAR (Cloud hoặc On-Premise Docker) để tái hiện lại 100% các kịch bản phản ứng sự cố.

---

## 📂 Danh Sách Các Workflow Tự Động Hóa

| STT | Tên File Workflow | Mục Tiêu & Chức Năng | Điểm Kích Hoạt (Trigger) | Các Ứng Dụng Liên Quan |
| :---: | :--- | :--- | :--- | :--- |
| **01** | [`workflow_nmap_recon_detection.json`](workflow_nmap_recon_detection.json) | Nhận cảnh báo Nmap từ Wazuh, tra cứu IP kẻ tấn công trên VirusTotal, chuẩn hóa dữ liệu 2-Pane và tạo Ticket Jira cảnh báo L12. | Webhook từ Wazuh Manager (Rule 100002 / Snort SID 1:1000005:2) | Wazuh, VirusTotal v3, Shuffle Tools, Jira Cloud v3 |
| **02** | [`workflow_nmap_firewall_block_ip.json`](workflow_nmap_firewall_block_ip.json) | Nhận lệnh 1-Click từ Jira (`☢️ CHẶN IP TẤN CÔNG`), lấy JWT token từ Wazuh API, kích hoạt Active Response cách ly IP bằng IPTables và cập nhật báo cáo vào Jira. | Webhook từ Jira Automation (Button Click) | Jira Cloud, Shuffle Tools, Wazuh REST API (`firewall-drop`) |
| **03** | [`workflow_fim_malware_detection.json`](workflow_fim_malware_detection.json) | Giám sát toàn vẹn file (FIM), đối soát mã băm SHA256 với VirusTotal. **Bộ lọc Gatekeeper**: Nếu file an toàn (`malicious == 0`), quy trình dừng ngay lập tức; nếu độc hại, tạo Ticket Jira 2-Pane. | Webhook từ Wazuh FIM (Rule 100055) | Wazuh FIM, VirusTotal v3, Shuffle Condition Node, Jira Cloud v3 |
| **04** | [`workflow_fim_active_response_delete_file.json`](workflow_fim_active_response_delete_file.json) | Nhận lệnh 1-Click từ Jira (`☢️ XÓA FILE MÃ ĐỘC`), bóc tách chính xác đường dẫn file Windows, gọi Wazuh API kích hoạt script PowerShell `remove-threat0` để tiêu diệt mã độc. | Webhook từ Jira Automation (Button Click) | Jira Cloud, Shuffle Tools, Wazuh REST API (`remove-threat0`) |
| **05** | [`workflow_gemini_ai_soc_triage.json`](workflow_gemini_ai_soc_triage.json) | Bộ thẩm định AI On-Demand: trích xuất toàn bộ telemetry từ Jira, áp dụng 8 quy tắc Prompt Zero-Hallucination, gọi Google Gemini Flash, chuyển hóa kết quả thành ADF Callout Panel đa màu sắc gửi về Jira. | Webhook từ Jira Automation (Button Click) | Jira Cloud, Google Gemini 2.5 Flash, Shuffle Tools (ADF Builder) |

---

## 🛠️ Hướng Dẫn Import Vào Shuffle SOAR

1. **Đăng nhập vào Shuffle SOAR** (Giao diện Web `http://<IP_SHUFFLE>:3001` hoặc Shuffler.io Cloud).
2. Di chuyển đến tab **Workflows** ➡️ Nhấp vào nút **Import Workflow**.
3. Chọn file JSON tương ứng (ví dụ: `workflow_fim_malware_detection.json`).
4. **Cấu hình Secret & Credential**:
   * **VirusTotal App**: Cung cấp API Key cá nhân trong phần Authentication của node `Virustotal_v3_1`.
   * **Jira App**: Cung cấp URL (`https://your-domain.atlassian.net`), Email và Jira API Token.
   * **Wazuh API**: Khai báo Username/Password của tài khoản Wazuh API để node `Get_Token` tạo JWT Bearer token hợp lệ.
   * **Google Gemini App**: Nhập Gemini API Key tại node `post_generate_content_with_flash`.
5. Bật trạng thái workflow sang **Active / Running**.
