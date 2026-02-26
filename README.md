# 📚 Phố Truyện (Pho Truyen)

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![Clean Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-green?style=for-the-badge)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

**Phố Truyện** là một ứng dụng đọc truyện (comics & novels) mã nguồn mở được xây dựng trên nền tảng **Flutter**. Dự án tập trung vào hiệu năng mượt mà, trải nghiệm người dùng tối ưu và cấu trúc code chuẩn mực để dễ dàng mở rộng.

---

## 📱 Thông tin Thử nghiệm Dự án
Video Demo iOS: https://youtu.be/KOa32vpljUU

Build APK: https://byvn.net/jeUJ

Tài khoản Test (Đã có sẵn Ruby):
Email: leminhmanh2004@gmail.com
Mật khẩu: 123456

---

## ✨ Tính năng chính

- 🔐 **Xác thực & Bảo mật:**
  - Đăng nhập/Đăng ký tài khoản (Email/Password).
  - Đăng nhập nhanh qua **Google** và **Facebook**.
  - Tự động làm mới phiên đăng nhập (Refresh Token).

- 📖 **Trải nghiệm đọc ưu việt:**
  - Hỗ trợ cuộn dọc, lật trang mượt mà.
  - Tùy chỉnh giao diện: Dark/Light settings, cỡ chữ, font chữ.
  - Tự động lưu lịch sử đọc.

- ✍️ **Dành cho Tác giả (Author Center):**
  - Đăng tải truyện mới với đầy đủ thông tin (Tags, Thể loại, Lịch ra chương).
  - Quản lý chương truyện (Thêm/Sửa/Xóa).
  - Thống kê lượt xem, theo dõi.

- 💬 **Tương tác & Cộng đồng:**
  - Bình luận, trả lời bình luận (Reply), thả tim.
  - Đánh giá truyện.
  - Nhận thông báo khi có chương mới hoặc tương tác.

- 💰 **Hệ thống thanh toán & Ví:**
  - Nạp Ruby qua cổng thanh toán.
  - Mua chương VIP, mở khóa nội dung.
  - Xem lịch sử giao dịch.

- 📚 **Thư viện cá nhân:**
  - Tủ sách yêu thích.
  - Đánh dấu truyện đang theo dõi.

---

## 🛠️ Công nghệ sử dụng (Tech Stack)

Dự án sử dụng các thư viện và công nghệ hiện đại nhất trong hệ sinh thái Flutter:

- **Core:** Flutter 3.x (Dart)
- **State Management & Routing:** [GetX](https://pub.dev/packages/get) (Quản lý trạng thái, Dependency Injection, Navigation)
- **UI Components:**
  - [Shadcn UI](https://pub.dev/packages/shadcn_ui) & [Forui](https://pub.dev/packages/forui) (Thiết kế hiện đại, tinh tế)
  - `flutter_widget_from_html` (Render nội dung HTML)
- **Networking:** [Dio](https://pub.dev/packages/dio) (REST API Client với Interceptors xử lý Token)
- **Local Storage:** `shared_preferences` (Lưu cấu hình, token)
- **Firebase Services:**
  - Firebase Messaging (Push Notification)
  - Firebase Core
- **Authentication:**
  - `google_sign_in`
  - `flutter_facebook_auth`
- **Utilities:** `intl` (Định dạng dữ liệu), `url_launcher`, `image_picker`.

---

## 🏗️ Kiến trúc dự án (Architecture)

Dự án được triển khai theo mô hình **Clean Architecture** để tách biệt mã nguồn thành các lớp độc lập:

```text
lib/
├── core/                # Tầng lõi: Chứa các cấu hình và tài nguyên dùng chung
│   ├── constants/       # Các hằng số (Colors, Styles, Strings)
│   ├── error/           # Xử lý ngoại lệ và định nghĩa lỗi (Failures)
│   ├── network/         # Cấu hình kết nối API, HttpClient (Dio)
│   ├── router/          # Quản lý điều hướng ứng dụng (GoRouter/AutoRoute)
│   ├── services/        # Các dịch vụ hệ thống (Firebase, Local Service)
│   ├── usecase/         # Lớp cơ sở cho các nghiệp vụ (Base UseCase)
│   └── widgets/         # Các Widget dùng chung mức độ hệ thống
├── features/            # Tầng tính năng: Chia theo nghiệp vụ (Feature-Driven)
│   ├── auth/            # Quản lý đăng nhập, đăng ký
│   ├── story/           # Hiển thị thông tin truyện và danh sách
│   ├── chapter/         # Trình đọc truyện và xử lý nội dung chương
│   ├── home/            # Giao diện chính và luồng dữ liệu trang chủ
│   └── ...              # Các module khác (search, comment, notification...)
├── shared/              # Các thành phần UI dùng chung giữa các features
│   └── widgets/         # Custom components (Button, Dialog, ItemHashtags...)
├── app.dart             # Cấu hình Root Widget (MaterialApp)
├── firebase_options.dart # Cấu hình kết nối Firebase
└── main.dart            # Điểm khởi chạy ứng dụng (Entry point)
