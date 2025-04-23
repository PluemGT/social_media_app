// Import แพ็คเกจที่ใช้
import 'package:firebase_auth/firebase_auth.dart'; // สำหรับใช้งาน Firebase Authentication
import 'package:flutter/material.dart'; // สำหรับ UI
import 'package:get/get.dart'; // สำหรับ Navigation และ Snackbar
import 'package:social_media_app/forgot.dart'; // หน้ารีเซ็ตรหัสผ่าน
import 'package:social_media_app/signup.dart'; // หน้าสมัครสมาชิก

// StatefulWidget สำหรับหน้า Login
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // ตัวแปรเก็บค่าที่ผู้ใช้กรอก
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  // ฟังก์ชันเข้าสู่ระบบ
  signIn() async {
    try {
      // เรียก Firebase SignIn ด้วยอีเมลและรหัสผ่าน
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      // แสดง snackbar แจ้งเข้าสู่ระบบสำเร็จ
      Get.snackbar(
        "Success",
        "Logged in successfully!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      // ถ้ามีข้อผิดพลาด แสดง snackbar แจ้งเตือน
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // ตั้งพื้นหลังสีดำ
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0), // ระยะห่างรอบจอ
          child: Column(
            children: [
              const SizedBox(height: 40),

              // โลโก้ตรงกลาง
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.yellow,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.yellow.withOpacity(0.6),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Y',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 50),

              // ช่องกรอกอีเมล
              TextField(
                controller: email,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter email',
                  hintStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ช่องกรอกรหัสผ่าน
              TextField(
                controller: password,
                obscureText: true, // ซ่อนรหัสผ่าน
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter password',
                  hintStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ปุ่มเข้าสู่ระบบ
              ElevatedButton(
                onPressed: signIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text("Login"),
              ),

              const SizedBox(height: 20),

              // ปุ่มลืมรหัสผ่าน
              TextButton(
                onPressed: () => Get.to(Forgot()),
                child: Text(
                  "Forgot password?",
                  style: TextStyle(color: Colors.yellow),
                ),
              ),

              const Spacer(), // ดันปุ่ม Register ลงล่างสุด

              // ส่วนสมัครสมาชิก
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () => Get.to(Signup()),
                    child: Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.yellow,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}