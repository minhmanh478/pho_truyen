# 📚 Phố Truyện (Pho Truyen)

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![Clean Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-green?style=for-the-badge)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

**Phố Truyện** là một ứng dụng đọc truyện (comics & novels) mã nguồn mở được xây dựng trên nền tảng **Flutter**. Dự án tập trung vào hiệu năng mượt mà, trải nghiệm người dùng tối ưu và cấu trúc code chuẩn mực để dễ dàng mở rộng.

---

## ✨ Tính năng chính

- 📖 **Đọc truyện đa nền tảng:** Hỗ trợ tốt trên cả Android và iOS.
- 🌓 **Chế độ đọc tối ưu:** Tùy chỉnh Dark/Light mode, font chữ, kích thước và lề.
- 📥 **Đọc Offline:** Tải và lưu trữ chương truyện vào bộ nhớ cục bộ.
- 💳 **Thanh toán:** Tích hợp hệ thống nạp tiền và mua chương truyện (Payment Gateway).
- 🔔 **Thông báo:** Cập nhật chương mới tức thì qua hệ thống Push Notification.
- 🔍 **Tìm kiếm thông minh:** Tìm kiếm truyện theo tên, tác giả hoặc thể loại.

---

## 🛠️ Công nghệ sử dụng (Tech Stack)

- **State Management:** `flutter_bloc` (hoặc Provider/GetX tùy bạn đang dùng).
- **Navigation:** `go_router` hoặc `auto_route`.
- **Local Storage:** `hive` hoặc `sqflite` để lưu cache và truyện offline.
- **Networking:** `dio` để thực hiện các yêu cầu API.
- **Dependency Injection:** `get_it` & `injectable`.

---

## 🏗️ Kiến trúc dự án (Architecture)

Dự án được triển khai theo mô hình **Clean Architecture** để tách biệt mã nguồn thành các lớp độc lập:

```text
lib/
├── core/               # Các hằng số, theme, utils và lỗi hệ thống
├── data/               # Triển khai Repository, Data Sources (Local/Remote) và Models (DTO)
├── domain/             # Chứa Entities, Business Logic (Use Cases) và Interfaces
├── presentation/       # Giao diện người dùng (Screens, Widgets) và GetX
└── main.dart           # File khởi chạy ứng dụng
