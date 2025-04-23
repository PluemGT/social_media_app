import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/warpper.dart';

/// หน้าลงทะเบียนผู้ใช้ใหม่
class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  // ตัวควบคุมการกรอกข้อมูล
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // ใช้สำหรับตรวจสอบฟอร์ม
  bool isLoading = false; // ใช้แสดง loading ระหว่างสมัครสมาชิก

  // ฟังก์ชันสมัครสมาชิก
  void signup() async {
    // ตรวจสอบว่ารหัสผ่านตรงกันหรือไม่
    if (password.text != confirmPassword.text) {
      Get.snackbar(
        "Password mismatch",
        "Both passwords must be the same",
        backgroundColor: Colors.black,
        colorText: Colors.yellow,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // สร้างบัญชีใหม่ใน Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim());

      // บันทึกข้อมูลผู้ใช้เพิ่มเติมลงใน Firestore
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'username': email.text.split('@')[0], // สร้าง username จากอีเมล
        'bio': 'Empty bio', // ตั้ง bio เริ่มต้น
      });

      // พาไปหน้า Warpper เพื่อตรวจสอบ login และ redirect
      Get.offAll(Warpper());
    } on FirebaseAuthException catch (e) {
      // แสดง error ถ้ามีปัญหาการสมัคร
      Get.snackbar(
        "Signup Error",
        e.message ?? "Unknown error",
        backgroundColor: Colors.black,
        colorText: Colors.redAccent,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Sign-up"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.yellow,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // ช่องกรอกอีเมล
              TextFormField(
                controller: email,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter email',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // ช่องกรอกรหัสผ่าน
              TextFormField(
                controller: password,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter password',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // ช่องยืนยันรหัสผ่าน
              TextFormField(
                controller: confirmPassword,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Confirm password',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // ปุ่มสมัครสมาชิก
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : signup, // ปิดปุ่มถ้า loading อยู่
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700],
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text("Sign Up"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}