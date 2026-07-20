#!/bin/bash

# --- CẤU HÌNH THÔNG SỐ (Hãy sửa lại cho đúng với máy của bạn) ---
GRUB_SRC_DIR="./grub_theme"                        # Thư mục chứa ảnh và file config trên máy bạn
ANDROID_IP="192.168.1.50"                          # IP của AndroidTV-x86 trong mạng LAN
ANDROID_GRUB_DIR="/mnt/grub/grub"                   # Thư mục GRUB mặc định trên Android-x86
# -----------------------------------------------------------

echo "🟢 Bắt đầu Workflow cấu hình GRUB Xanh Lá Sọc cho AndroidTV-x86..."

# 1. Kết nối tới AndroidTV qua ADB
echo "🔌 Đang kết nối tới thiết bị AndroidTV-x86 ($ANDROID_IP)..."
adb disconnect > /dev/null 2>&1
adb connect $ANDROID_IP

# Kiểm tra xem có kết nối thành công không
if [ $? -ne 0 ]; then
    echo "❌ Không thể kết nối ADB tới $ANDROID_IP. Vui lòng kiểm tra lại IP hoặc Wifi!"
    exit 1
fi

# 2. Chuyển phân vùng GRUB sang quyền ghi (Read-Write)
echo "🔓 Đang mount phân vùng GRUB thành Read-Write..."
adb shell "su -c 'mount -o remount,rw /mnt/grub'"

# 3. Copy file ảnh nền sọc xanh lá và file cấu hình mới vào AndroidTV
echo "📦 Đang copy file ảnh nền và cấu hình GRUB..."
# Tạo thư mục lưu theme tạm thời trên Android trước khi chuyển vào hệ thống
adb shell "mkdir -p /sdcard/grub_tmp"
adb push "$GRUB_SRC_DIR/green_stripes.png" "/sdcard/grub_tmp/"
adb push "$GRUB_SRC_DIR/grub.cfg" "/sdcard/grub_tmp/"

# Dùng quyền root để di chuyển file vào đúng phân vùng GRUB
adb shell "su -c 'cp /sdcard/grub_tmp/green_stripes.png $ANDROID_GRUB_DIR/'"
adb shell "su -c 'cp /sdcard/grub_tmp/grub.cfg $ANDROID_GRUB_DIR/'"

# Xóa file tạm cho sạch máy
adb shell "rm -rf /sdcard/grub_tmp"

# 4. Khởi động lại để kiểm tra kết quả
echo "✅ Đã copy xong cấu hình GRUB Xanh Lá Sọc!"
read -p "🔄 Bạn có muốn khởi động lại AndroidTV để xem kết quả không? (y/n): " choice
if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    echo "🚀 Đang khởi động lại AndroidTV..."
    adb reboot
else
    echo "⏸️  Workflow kết thúc. Hãy tự khởi động lại máy sau nhé."
fi
