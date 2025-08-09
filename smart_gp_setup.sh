#!/bin/bash

echo "🚀 بدء تجهيز بيئة GlobalPlatformPro"

# الخطوة 1: تحديد JAVA_HOME تلقائيًا
JAVA_PATH=$(readlink -f $(which java))
JAVA_HOME=$(dirname $(dirname "$JAVA_PATH"))

echo "🔍 تحديد JAVA_HOME: $JAVA_HOME"
export JAVA_HOME="$JAVA_HOME"

# تثبيت الأدوات الأساسية
sudo apt update
sudo apt install default-jdk maven ant make -y

echo "✅ الأدوات جاهزة، جاري الدخول لمجلد المشروع..."

# دخول مجلد المشروع
cd ~/Downloads/GlobalPlatformPro || {
    echo "❌ لم يتم العثور على مجلد GlobalPlatformPro"; exit 1;
}

# الخطوة 2: التحقق من وجود ملف pom.xml (علامة وجود مشروع Maven)
if [[ ! -f "pom.xml" ]]; then
    echo "❌ لا يوجد ملف pom.xml في هذا المجلد، البناء باستخدام Maven غير ممكن."
    exit 1
fi

# الخطوة 3: تنفيذ البناء
echo "⚙️ تنفيذ أمر: mvn clean package ..."
mvn clean package

# الخطوة 4: البحث عن ملف jar الناتج
JAR_FILE=$(find . -name "globalplatform*.jar" | head -n 1)

if [[ -f "$JAR_FILE" ]]; then
    echo "✅ تم العثور على: $JAR_FILE"
    echo "📡 تشغيل gp -list ..."
    java -jar "$JAR_FILE" -list
else
    echo "❌ لم يتم العثور على ملف Jar داخل المشروع"
fi
