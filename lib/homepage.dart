// Import แพ็กเกจต่าง ๆ ที่ใช้ในแอป
import 'package:cloud_firestore/cloud_firestore.dart'; // ใช้งาน Firestore
import 'package:firebase_auth/firebase_auth.dart'; // ใช้งาน Firebase Authentication
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // ใช้จัดรูปแบบวันที่และเวลา
import 'package:social_media_app/component/Text_field.dart'; // ฟอร์มกรอกข้อความ
import 'package:social_media_app/component/Y_post.dart'; // Widget โพสต์
import 'package:social_media_app/component/drawer.dart'; // เมนู Drawer
import 'package:social_media_app/profile_page.dart'; // หน้าโปรไฟล์

// สร้าง StatefulWidget สำหรับหน้าแรกของแอป
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final user = FirebaseAuth.instance.currentUser; // ผู้ใช้ที่ล็อกอินอยู่
  final textcontroller = TextEditingController(); // ควบคุมช่องกรอกข้อความ

  // เมธอดออกจากระบบ
  void signout() async {
    await FirebaseAuth.instance.signOut();
  }

  // เมธอดโพสต์ข้อความ
  void postMessage() {
    if (textcontroller.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("User post").add({
        'UserEmail': user!.email, // อีเมลของผู้โพสต์
        'Message': textcontroller.text, // ข้อความ
        'TimeStamp': Timestamp.now(), // เวลาที่โพสต์
        'Likes': [] // เริ่มต้นไลก์เป็น array ว่าง
      });
    }

    // ล้างช่องข้อความหลังโพสต์
    setState(() {
      textcontroller.clear();
    });
  }

  // เมธอดนำทางไปยังหน้าโปรไฟล์
  void GotoprofilePage() {
    Navigator.pop(context); // ปิด Drawer ก่อน
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[300], // พื้นหลังสีเหลือง
      appBar: AppBar(
        title: Center(
          child: Text(
            "Welcome to Y",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: GotoprofilePage, // ปุ่มไปหน้าโปรไฟล์
            icon: Icon(Icons.person),
          )
        ],
      ),

      // Drawer เมนูด้านซ้าย
      drawer: MyDrawer(
        onProfileTap: GotoprofilePage, // ไปหน้าโปรไฟล์
        onsignOut: signout, // ออกจากระบบ
      ),

      body: Center(
        child: Column(
          children: [
            // โซนแสดงโพสต์ทั้งหมด
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("User post")
                    .orderBy("TimeStamp", descending: false)
                    .snapshots(), // ดึงโพสต์เรียงตามเวลา
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final post = snapshot.data!.docs[index];
                        final timestamp = post['TimeStamp'] as Timestamp;
                        final datetime = timestamp.toDate();
                        final formattedTime =
                            DateFormat('yyyy-MM-dd HH:mm').format(datetime);

                        return YPost(
                          message: post['Message'],
                          user: post['UserEmail'],
                          time: formattedTime,
                          postID: post.id,
                          likes: List<String>.from(post['Likes'] ?? []),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),

            // โซนกรอกและโพสต์ข้อความ
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  // ช่องกรอกข้อความ
                  Expanded(
                    child: MyTextfield(
                      controller: textcontroller,
                      hintText: "need to post some things.. ? ",
                      obscureText: false,
                    ),
                  ),

                  // ปุ่มโพสต์ข้อความ
                  IconButton(
                    onPressed: postMessage,
                    icon: const Icon(Icons.arrow_circle_up),
                  )
                ],
              ),
            ),

            // แสดงอีเมลผู้ใช้งาน
            Text(
              'Login as: ${user!.email}',
              style: TextStyle(color: Colors.black),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}