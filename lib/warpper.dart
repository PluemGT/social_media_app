import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/homepage.dart';
import 'package:social_media_app/login.dart';
import 'package:social_media_app/vertifyemail.dart';

/// Warpper เป็น widget ที่คอยตรวจสอบสถานะของผู้ใช้
/// ว่า login แล้วหรือยัง และ email ได้รับการยืนยันแล้วหรือไม่
class Warpper extends StatefulWidget {
  const Warpper({super.key});

  @override
  State<Warpper> createState() => _WarpperState();
}

class _WarpperState extends State<Warpper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ใช้ StreamBuilder เพื่อติดตามสถานะของการ login
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(), 
        builder: (context, snapshot) {
          // ถ้ามีข้อมูล แปลว่าผู้ใช้ login แล้ว
          if (snapshot.hasData) {
            print(snapshot.data);  // สำหรับ debug แสดงข้อมูล user

            // ตรวจสอบว่า email ได้ถูกยืนยันหรือยัง
            if (snapshot.data!.emailVerified) {
              return Homepage(); // ถ้ายืนยันแล้ว ไปหน้า homepage
            } else {
              return Vertify();  // ถ้ายังไม่ยืนยัน ไปหน้า verify email
            }
          } else {
            // ถ้ายังไม่มีข้อมูลผู้ใช้ แปลว่ายังไม่ได้ login
            return Login(); // กลับไปหน้า login
          }
        },
      ),
    );
  }
}