#!/bin/bash

# 1. Định nghĩa các đường dẫn
SOURCE_DIR="/path/to/your/android-x86/source"
TARGET_DIR="/path/to/your/backup/or/usb"
TV_IP="192.168.1.50" # IP của AndroidTV trong mạng LAN

echo "🤖 Bắt đầu Workflow xử lý code AndroidTV-x86..."

# 2. Đồng bộ code giữa các thư mục (Sử dụng rsync để copy nhanh, bỏ qua file trùng)
echo "📦 Đang copy và đồng bộ nguồn code..."
rsync -av --exclude='.git' --exclude='.gradle' "$SOURCE_DIR/" "$TARGET_DIR/"

# 3. (Tùy chọn) Nếu muốn cài đặt thẳng file build (.apk) vào AndroidTV qua ADB
echo "🔌 Đang kết nối tới AndroidTV-x86 qua ADB..."
adb connect $TV_IP

echo "📲 Đang cài đặt ứng dụng vào AndroidTV..."
adb -s $TV_IP:5555 install -r "$SOURCE_DIR/app/build/outputs/apk/debug/app-debug.apk"

echo "✅"
