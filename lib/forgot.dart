import 'package:firebase_auth/firebase_auth.dart'; // ดึง Firebase Authentication มาใช้งาน
import 'package:flutter/material.dart';

// สร้างหน้าจอ Forgot ซึ่งเป็น StatefulWidget เพราะมีการเปลี่ยนแปลงสถานะได้
class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  // ตัวแปรสำหรับเก็บอีเมลที่ผู้ใช้กรอก
  final TextEditingController email = TextEditingController();

  // ฟังก์ชันสำหรับส่งอีเมลลิงก์รีเซ็ตรหัสผ่าน
  Future<void> reset() async {
    final userEmail = email.text.trim(); // ตัดช่องว่างอีเมลออก
    if (userEmail.isEmpty) {
      // ถ้าไม่ได้กรอกอีเมล
      showSnackbar("⚠️ Please enter an email");
      return;
    }

    try {
      // เรียกใช้งาน Firebase เพื่อส่งอีเมลรีเซ็ตรหัสผ่าน
      await FirebaseAuth.instance.sendPasswordResetEmail(email: userEmail);
      showSnackbar("📩 Reset link sent to $userEmail");
    } catch (e) {
      // แสดงข้อผิดพลาดถ้ามีปัญหา
      showSnackbar("❌ Error: ${e.toString()}");
    }
  }

  // ฟังก์ชันแสดง Snackbar สำหรับแจ้งเตือนผู้ใช้
  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // พื้นหลังสีดำ
      appBar: AppBar(
        title: const Text("Forgot Password"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.yellow,
        elevation: 0, // ไม่มีเงา
      ),
      body: Center(
        child: Card(
          color: Colors.grey[900], // พื้นหลังการ์ดสีเทาเข้ม
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // ขนาดคอลัมน์ตามเนื้อหาภายใน
              children: [
                const Icon(Icons.lock_reset_rounded, size: 60, color: Colors.yellow),
                const SizedBox(height: 20),
                const Text(
                  'Reset Your Password',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                // ช่องกรอกอีเมล
                TextField(
                  controller: email,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: Colors.black,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.email, color: Colors.yellow),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                // ปุ่มส่งลิงก์รีเซ็ตรหัสผ่าน
                ElevatedButton.icon(
                  onPressed: reset,
                  icon: const Icon(Icons.send, color: Colors.black),
                  label: const Text("Send Reset Link", style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700],
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}