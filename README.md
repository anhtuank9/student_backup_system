# Student Backup System

## 1. Giới thiệu dự án

`student_backup_system` là chương trình Bash Script dùng để tự động sao lưu dữ liệu trong Linux.

Chương trình thực hiện các chức năng chính:

- Tạo cấu trúc thư mục lưu dữ liệu, backup, log và script.
- Tạo dữ liệu mẫu trong thư mục `data/`.
- Nén thư mục `data/` thành file `.tar.gz`.
- Lưu file backup vào thư mục `backups/`.
- Ghi log quá trình backup vào `logs/backup.log`.
- Kiểm tra kết nối Internet bằng lệnh `ping`.
- Hiển thị menu thao tác trong terminal.
- Tự động chạy backup bằng cronjob mỗi 5 phút.
- Tự động commit và push dữ liệu lên GitHub.
- Chỉ giữ lại 5 file backup mới nhất.
- Thêm màu cho menu terminal.

---

## 2. Cấu trúc thư mục project

Project có cấu trúc như sau:

```text
student_backup_system/
├── data/
├── backups/
├── logs/
└── scripts/
