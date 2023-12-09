import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'color/color.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 기존 로그인 코드
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final UserCredential authResult = await _auth.signInWithCredential(credential);

    return authResult;
  }

  Future<void> checkAndNavigate(UserCredential userCredential) async {
    try {
      final String uid = userCredential.user!.uid;

      var userDoc = await _firestore.collection('user').doc(uid).collection('login').doc(uid).get();

      if (userDoc.exists) {
        bool addAccount = userDoc['addAccount'] ?? false;

        if (addAccount) {
          Navigator.pushReplacementNamed(
            context, '/home',
          );
        } else {
          Navigator.pushReplacementNamed(
            context, '/onboarding',
          );
        }
      } else {
        Navigator.pushReplacementNamed(
          context, '/onboarding',
        );
      }
    } catch (e) {
      print('Error during user document retrieval: $e');
    }
  }



  void _onLoginSuccess(UserCredential userCredential) async {
    await checkAndNavigate(userCredential);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Text('쉽고 빠르고 간편하게 공부하는 즐거움',style: GoogleFonts.nanumGothic(
                color: Colors.grey,
                fontSize: 10,
              ),),
            ),
            Text('Study Joy',style: GoogleFonts.katibeh(
                color: Colors.black, fontWeight: FontWeight.bold,fontSize: 50),),
            SizedBox(height: 10,),

            Container(
              child: ElevatedButton(
                onPressed: () async {
                  UserCredential userCredential = await signInWithGoogle();
                  if (userCredential != null) {
                    _onLoginSuccess(userCredential);
                    final String uid = userCredential.user!.uid;
                    final String? email = userCredential.user?.email;
                    final String? photoUrl = userCredential.user?.photoURL;
                    final String? name = userCredential.user?.displayName;

                    // Check if the user document already exists
                    var userDoc = await _firestore.collection('user').doc(uid).get();

                    if (!userDoc.exists || userDoc['lectureList'] == null) {
                      // If the user document doesn't exist or lectureList is null, create it with an empty lectureList
                      await _firestore.collection('user').doc(uid).set({
                        'uid': uid,
                        'email': email ?? '',
                        'photoUrl': photoUrl ?? '',
                        'name': name,
                        'lectureList': [],
                      });
                    }
                    FieldValue serverTimestamp = FieldValue.serverTimestamp();


                    // Firestore에 서버 시간으로 날짜 저장
                    await FirebaseFirestore.instance
                        .collection('event')
                        .doc(uid)
                        .set(
                        {'lastLoginDate': serverTimestamp}, SetOptions(merge: true));
                  }
                },
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 10,),
                        Text('구글 계정으로 시작하기',
                          style: TextStyle(color: Colors.white, fontSize: 15.0),
                        ),
                      ],
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColor.primary,
                  minimumSize: Size.fromHeight(50), // 높이만 50으로 설정
                  elevation: 1.0,
                  shape: RoundedRectangleBorder(
                    // shape : 버튼의 모양을 디자인 하는 기능
                      borderRadius: BorderRadius.circular(30.0)),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}