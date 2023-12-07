import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:teamwork/color/color.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? userUID;
  String? userEmail;
  String? userPhoto;
  String? userName;
  // 전공 추가
  String userMajor = '';
  bool isGoogleSignIn = false;

  void _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      GoogleSignIn().disconnect();
      Navigator.pushNamed(context, '/');
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
    fetchMajor();
  }

  void fetchUser(){
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userUID = user.uid;
        userEmail = user.email;
        userPhoto = user.photoURL;
        userName = user.displayName;
      });
    }
  }
  Future<void> fetchMajor() async {
      try {
        var snapshot = await FirebaseFirestore.instance
            .collection('user')
            .doc(userUID)
            .get();
          setState(() {
            userMajor = snapshot['major'];
          });
      } catch (e) {
        print('Error fetching data from Firestore: $e');
      }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Page',style: GoogleFonts.abrilFatface(color: Colors.white,fontSize: 25)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: CustomColor.primary,
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () => _signOut(context),
            icon: Icon(Icons.exit_to_app, color: Colors.white),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 400,
              height: 550,
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.scale(
                      scale: 1.4,
                      child: Transform.translate(
                        offset: Offset(0,-195),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(userPhoto!),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(height: 60),
                          Row(
                            children: [
                              Text("이름 : ",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                              Text(userName!,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            ],
                          ),

                          Row(
                            children: [
                              Text("계정 이메일 : ",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                              Text(userEmail!,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            ],
                          ),

                          Row(
                            children: [
                              Text("전공 : ",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                              Text(userMajor!,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            ],
                          ),

                          SizedBox(height: 20,),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
      backgroundColor: CustomColor.primary,
    );
  }
}
