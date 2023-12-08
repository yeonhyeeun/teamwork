import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teamwork/color/color.dart';
import 'package:teamwork/study_func/quiz.dart';

class StudyPage extends StatefulWidget {
  const StudyPage({Key? key}) : super(key: key);

  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  String? userUID;
  Stream<DocumentSnapshot>? _userLectureStream;

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
        _userLectureStream = FirebaseFirestore.instance.collection('user').doc(userUID).snapshots();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 200,
        height: 50,
        child: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/addquiz');
            },
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
            side: BorderSide(width: 2,color: CustomColor.primary),
          ),
            child: Text('문제 직접 등록하기',
              style: GoogleFonts.nanumGothic(
              color: Colors.black,
              fontWeight: FontWeight.bold,
                fontSize: 16
            ),),
          ),
      ),
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
      body: StreamBuilder<DocumentSnapshot>(
        stream: _userLectureStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Container();
          }

          var userDocument = snapshot.data!;
          var lectureList = userDocument['lectureList'] ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10,),
              Text(
                '${userDocument['name']}의 스터디룸',
                style: GoogleFonts.nanumGothic(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
              for (var lectureId in lectureList)
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('lecture').doc(lectureId).get(),
                  builder: (context, lectureSnapshot) {
                    if (lectureSnapshot.hasError) {
                      return Text('Error: ${lectureSnapshot.error}');
                    }

                    if (!lectureSnapshot.hasData || !lectureSnapshot.data!.exists) {
                      return Container();
                    }

                    var lectureData = lectureSnapshot.data!;
                    var lectureName = lectureData['name'];

                    return Center(
                      child: Column(
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
                                onLongPress: () async {
                                  bool confirmDelete = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.white,
                                        elevation: 0.0,
                                        title: Text("강의 삭제"),
                                        content: Text("수강 목록에서 삭제하시겠습니까?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(false); // User doesn't want to delete
                                            },
                                            child: Text("취소",style:  GoogleFonts.nanumGothic(
                                                color: Colors.black,
                                                )),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(true); // User confirms deletion
                                            },
                                            child: Text("삭제",style: GoogleFonts.nanumGothic(
                                              color: Colors.red,
                                            ),),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (confirmDelete == true) {
                                    // User confirmed deletion, perform deletion here
                                    await FirebaseFirestore.instance.collection('user').doc(userUID).update({
                                      'lectureList': FieldValue.arrayRemove([lectureId])
                                    });
                                  }
                                },
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
                                        colors: [Color(0xff9fccfa),Color(0xff0974f1)]
                                    ),
                                    borderRadius: BorderRadius.circular(17),
                                  ),
                                  child: Align(
                                    alignment : Alignment.center,
                                    child: Text(
                                      lectureName,
                                      style: GoogleFonts.russoOne(
                                        color: Colors.black,
                                        fontSize: 23,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
