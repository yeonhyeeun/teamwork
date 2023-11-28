import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teamwork/color/color.dart';
import 'package:teamwork/quiz.dart';

class StudyPage extends StatefulWidget {
  const StudyPage({Key? key}) : super(key: key);

  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  String? userUID;

  @override
  void initState() {
    super.initState();
    fetchUserUID();
  }

  void fetchUserUID() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userUID = user.uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.primary,
        centerTitle: true,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Text(
          '수강 목록',
          style: GoogleFonts.nanumGothic(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('user').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Container();
          }

          var documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              var userDocument = documents[index];
              var documentUID = userDocument.id;

              // Check if the document UID matches the current user's UID
              if (userUID != null && documentUID == userUID) {
                var lectureList = userDocument['lectureList'] ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10,),
                    Text(
                      '${userDocument['name']}의 스터디룸',
                      style: GoogleFonts.nanumGothic(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    for (var lectureId in lectureList)
                      FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance.collection('lecture').doc(lectureId).get(),
                        builder: (context, lectureSnapshot) {
                          if (lectureSnapshot.hasError) {
                            return Text('Error: ${lectureSnapshot.error}');
                          }

                          if (!lectureSnapshot.hasData) {
                            return Container();
                          }

                          var lectureData = lectureSnapshot.data!;
                          var lectureName = lectureData['name'];

                          return Column(
                            children: [
                              SizedBox(height: 10,),
                              SizedBox(
                                height: 70,
                                width: 320,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => QuizPage(lectureId: lectureId),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient : LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [Color(0xfffff1eb),Color(0xfface0f9)]
                                        ),
                                        borderRadius: BorderRadius.circular(17),
                                      ),
                                      child: Align(
                                        alignment : Alignment.center,
                                        child: Text(
                                          lectureName,
                                          style: GoogleFonts.nanumGothic(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 23,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                  ],
                );
              } else {
                // Return an empty container if the document UID does not match the current user's UID
                return Container();
              }
            },
          );
        },
      ),
    );
  }
}
