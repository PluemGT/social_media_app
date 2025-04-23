import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/warpper.dart';

/// หน้านี้ใช้แสดงข้อความแจ้งเตือนให้ผู้ใช้ทำการยืนยันอีเมล
/// พร้อมทั้งมีปุ่ม reload และ sign out
class Vertify extends StatefulWidget {
  const Vertify({super.key});

  @override
  State<Vertify> createState() => _VertifyState();
}

class _VertifyState extends State<Vertify> with SingleTickerProviderStateMixin {
  // สร้าง animation สำหรับการ fade in
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // เรียกฟังก์ชันส่งลิงก์ยืนยันอีเมลเมื่อเปิดหน้า
    sendVerificationLink();

    // สร้าง animation controller และเริ่มเล่น
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();

    // สร้าง fade animation
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _controller.dispose(); // ทำลาย animation controller เมื่อ widget ถูกถอดออก
    super.dispose();
  }

  // ส่งลิงก์ยืนยันไปยังอีเมลของผู้ใช้
  void sendVerificationLink() async {
    final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification().then((value) {
      Get.snackbar(
        'Link Sent!',
        'A verification link has been sent to your email.',
        backgroundColor: Colors.black,
        colorText: Colors.yellow,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20),
      );
    });
  }

  // รีโหลดข้อมูลผู้ใช้ (เช่น ตรวจสอบว่าได้ยืนยันเมลแล้วหรือยัง)
  void reload() async {
    await FirebaseAuth.instance.currentUser!.reload();
    Get.offAll(Warpper()); // รีโหลดและกลับไปที่หน้า Warpper เพื่อให้ตรวจสอบสถานะใหม่
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // พื้นหลังสีดำ
      appBar: AppBar(
        title: const Text("Email Verification"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.yellow, // สีตัวหนังสือใน AppBar
        elevation: 0,
      ),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation, // เอฟเฟกต์ fade
          child: Card(
            color: Colors.grey[900],
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            margin: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ไอคอน email
                  Icon(Icons.email_outlined, size: 64, color: Colors.yellow[700]),
                  const SizedBox(height: 20),
                  const Text(
                    'Please check your email',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  // ข้อความแนะนำให้เปิดอีเมล
                  Text(
                    'Open your mail and click on the link provided to verify your email address.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // ปุ่มลอยด้านล่าง
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // ปุ่ม reload สำหรับเช็คสถานะว่าอีเมลยืนยันแล้วหรือยัง
            FloatingActionButton(
              heroTag: 'reload',
              onPressed: reload,
              backgroundColor: Colors.yellow[700],
              child: const Icon(Icons.restart_alt_rounded, color: Colors.black),
              tooltip: 'Reload & Continue',
            ),
            const SizedBox(width: 16),
            // ปุ่ม logout กลับไป login ใหม่
            FloatingActionButton(
              heroTag: 'backToLogin',
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Get.offAll(Warpper());
              },
              backgroundColor: Colors.grey[800],
              child: const Icon(Icons.logout, color: Colors.white),
              tooltip: 'Back to Login',
            ),
          ],
        ),
      ),
    );
  }
}