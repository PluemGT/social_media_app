import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:get/route_manager.dart';
import 'package:intl/intl.dart'; 
import 'package:social_media_app/component/Text_field.dart';
import 'package:social_media_app/component/Y_post.dart';
import 'package:social_media_app/component/drawer.dart';
import 'package:social_media_app/profile_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final user = FirebaseAuth.instance.currentUser;
  final textcontroller = TextEditingController();

  // sign out method
  void signout() async {
    await FirebaseAuth.instance.signOut();
  }

  // post method
  void postMessage() {
    if (textcontroller.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("User post").add({
        'UserEmail': user!.email,
        'Message': textcontroller.text,
        'TimeStamp': Timestamp.now(),
        'Likes':[]
      });
    }
    setState(() {
      textcontroller.clear();
    });
  }

  //navication pro
  void GotoprofilePage(){
    //popmeun
    Navigator.pop(context);
     //go to profile user
     Navigator.push(context,MaterialPageRoute(builder:(context)=> const ProfilePage(),));
  }
 
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[300],
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
            onPressed: GotoprofilePage,
            icon: Icon(Icons.person),
          )
        ],
      ),
      drawer: MyDrawer(
       onProfileTap: GotoprofilePage,
       onsignOut:signout,

      ),
      body: Center(
        child: Column(
          children: [
            // Y app
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("User post")
                    .orderBy("TimeStamp", descending: false)
                    .snapshots(),
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
                          time: formattedTime, // ✅ แก้ตรงนี้
                          postID: post.id,
                          likes: List<String>.from(post['Likes']??[]),
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



            // post
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextfield(
                      controller: textcontroller,
                      hintText: "need to post some things.. ? ",
                      obscureText: false,
                    ),
                  ),
                  IconButton(
                      onPressed: postMessage,
                      icon: const Icon(Icons.arrow_circle_up))
                ],
              ),
            ),

            // Text
            Text('Login as: ${user!.email}',style: TextStyle(color: Colors.black),),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}