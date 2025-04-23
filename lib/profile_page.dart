// Import แพ็คเกจที่จำเป็น
import 'package:cloud_firestore/cloud_firestore.dart'; // สำหรับดึงข้อมูลจาก Firestore
import 'package:firebase_auth/firebase_auth.dart'; // สำหรับเข้าถึงผู้ใช้งานปัจจุบัน
import 'package:flutter/material.dart'; // สำหรับ UI
import 'package:social_media_app/component/text_box.dart'; // TextBox custom ของแอป

// สร้าง StatefulWidget สำหรับหน้าโปรไฟล์
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // ดึงข้อมูลผู้ใช้ปัจจุบันจาก Firebase Authentication
  final user = FirebaseAuth.instance.currentUser!;

  // อ้างอิง Collection "Users" จาก Firestore
  final userCollection = FirebaseFirestore.instance.collection("Users");

  // ฟังก์ชันสำหรับแก้ไขข้อมูล (username หรือ bio)
  Future<void> editField(String field) async {
    String newValue = "";

    // แสดงกล่อง dialog ให้ผู้ใช้กรอกค่าที่ต้องการแก้ไข
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Edit $field", // ชื่อ field ที่จะแก้
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: TextStyle(color: Colors.grey[600]),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.yellow),
            ),
          ),
          onChanged: (value) {
            newValue = value; // บันทึกค่าที่ผู้ใช้พิมพ์
          },
        ),
        actions: [
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            onPressed: () => Navigator.pop(context), // ปิด dialog
          ),
          TextButton(
            child: const Text('Save', style: TextStyle(color: Colors.yellow)),
            onPressed: () => Navigator.of(context).pop(newValue), // ส่งค่ากลับ
          ),
        ],
      ),
    );

    // อัปเดตข้อมูลใน Firestore ถ้าค่าที่กรอกไม่ว่าง
    if (newValue.trim().isNotEmpty) {
      await userCollection.doc(user.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // พื้นหลังของหน้าจอ

      // AppBar ส่วนบนของหน้าจอ
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
        backgroundColor: Colors.yellow[800],
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      // ใช้ StreamBuilder เพื่อดึงข้อมูลโปรไฟล์แบบเรียลไทม์จาก Firestore
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(user.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // ถ้าดึงข้อมูลสำเร็จ
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const SizedBox(height: 20),

                // รูปโปรไฟล์
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.yellow,
                  child: Icon(Icons.person, size: 40, color: Colors.black),
                ),
                const SizedBox(height: 12),

                // แสดงอีเมลผู้ใช้งาน
                Text(
                  '${user.email}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[400], fontSize: 16),
                ),

                const SizedBox(height: 30),

                // ส่วนแสดงข้อมูลส่วนตัว
                const Text(
                  'My Details',
                  style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // แสดง username พร้อมปุ่มแก้ไข
                MYTextBox(
                  text: userData['username'],
                  sectionName: 'username',
                  onPressed: () => editField('username'),
                ),
                const SizedBox(height: 10),

                // แสดง bio พร้อมปุ่มแก้ไข
                MYTextBox(
                  text: userData['bio'],
                  sectionName: 'bio',
                  onPressed: () => editField('bio'),
                ),
                const SizedBox(height: 40),

                // ส่วนแสดงโพสต์ของผู้ใช้
                const Text(
                  'My Posts',
                  style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // TODO: เพิ่ม Widget แสดงโพสต์ของผู้ใช้ตรงนี้
                // เช่น ใช้ StreamBuilder ดึงจากคอลเลกชัน "Posts"
              ],
            );
          } else if (snapshot.hasError) {
            // กรณีดึงข้อมูลล้มเหลว
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          // ระหว่างกำลังโหลดข้อมูล
          return const Center(child: CircularProgressIndicator(color: Colors.yellow));
        },
      ),
    );
  }
}