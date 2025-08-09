#!/bin/bash

echo "🔧 بدء إعداد بيئة العمل..."

# تحديث النظام
sudo apt update && sudo apt upgrade -y

# تثبيت JDK (نسخة متوافقة مع كالي)
sudo apt install default-jdk -y

# تثبيت أدوات البناء الإضافية
sudo apt install ant maven make -y

echo "✅ الأدوات المطلوبة تم تثبيتها."

# الدخول إلى مجلد المشروع
cd ~/Downloads/GlobalPlatformPro || {
    echo "❌ لا يمكن الدخول إلى المجلد. تأكد من المسار."; exit 1;
}

# بناء المشروع باستخدام make (بما أن gradlew غير موجود)
echo "⚙️ بدء عملية البناء..."
make

# التأكد من وجود ملف Jar بعد البناء
echo "📦 التحقق من ملفات Jar داخل build/libs..."
find . -name "*.jar"

# محاولة تشغيل الأمر list على البطاقة
echo "🚀 تشغيل ملف jar..."
JAR_FILE=$(find . -name "globalplatform*.jar" | head -n 1)

if [[ -f "$JAR_FILE" ]]; then
    java -jar "$JAR_FILE" -list
else
    echo "❌ لم يتم العثور على ملف jar."
fi
