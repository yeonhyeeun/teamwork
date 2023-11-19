import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:teamwork/nav.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  Future<UserCredential> signInAnonymously() async {
    return await _auth.signInAnonymously();
  }

  void _onLoginSuccess(UserCredential userCredential) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BottomNavigation()),
    );


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 10.0),
            const Text('Handong Shopping',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () async {
                UserCredential userCredential = await signInWithGoogle();
                if (userCredential != null) {
                  _onLoginSuccess(userCredential);
                  final String uid = userCredential.user!.uid;
                  final String? email = userCredential.user?.email;
                  final String? photoUrl = userCredential.user?.photoURL;
                  final String? name = userCredential.user?.displayName;

                  await _firestore.collection('user').doc(uid).set({
                    'uid': uid,
                    'email': email ?? '',
                    'photoUrl': photoUrl ?? '',
                    'name': name,
                  });
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 10,),
                  Text('Google Login',
                    style: TextStyle(color: Colors.black87, fontSize: 15.0),
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50), // 높이만 50으로 설정
                elevation: 1.0,
                shape: RoundedRectangleBorder(
                  // shape : 버튼의 모양을 디자인 하는 기능
                    borderRadius: BorderRadius.circular(4.0)),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

