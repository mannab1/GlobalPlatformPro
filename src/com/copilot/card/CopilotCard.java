package com.copilot.card;

import javacard.framework.*;

public class CopilotCard extends Applet {

    // البيانات الرمزية
    private final byte[] name = { 'C', 'o', 'p', 'i', 'l', 'o', 't' };
    private final byte[] surname = { 'T', 'a', 'l', 'e', 'e', 'm', 'i' };
    private final byte[] birthdate = { 0x20, 0x23, 0x02, 0x07 }; // YYYYMMDD
    private final byte[] logo = { 0x01, 0x02, 0x03 }; // رموز رمزية للصورة

    // معرف التطبيق (AID)
    public static final byte[] AID = { (byte)0xA0, 0x00, 0x00, 0x01, 0x51, 0x00, 0x00, 0x01 };

    // إنشاء التطبيق
    public static void install(byte[] bArray, short bOffset, byte bLength) {
        new CopilotCard();
    }

    // تهيئة التطبيق
    protected CopilotCard() {
        register();
    }

    // التعامل مع الأوامر
    public void process(APDU apdu) {
        byte[] buffer = apdu.getBuffer();

        if (selectingApplet()) return;

        switch (buffer[1]) {
            case (byte) 0x01: // قراءة الاسم
                sendData(apdu, name);
                break;
            case (byte) 0x02: // قراءة الكنية
                sendData(apdu, surname);
                break;
            case (byte) 0x03: // قراءة تاريخ الميلاد
                sendData(apdu, birthdate);
                break;
            case (byte) 0x04: // قراءة الصورة الرمزية
                sendData(apdu, logo);
                break;
            default:
                ISOException.throwIt(ISO7816.SW_INS_NOT_SUPPORTED);
        }
    }

    // إرسال البيانات
    private void sendData(APDU apdu, byte[] data) {
        byte[] buffer = apdu.getBuffer();
        short length = (short) data.length;
        Util.arrayCopy(data, (short) 0, buffer, (short) 0, length);
        apdu.setOutgoingAndSend((short) 0, length);
    }
}

