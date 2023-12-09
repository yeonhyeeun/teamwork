import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:teamwork/color/color.dart';
import 'package:teamwork/home_func/search.dart';
import 'package:teamwork/login.dart';

import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  num _value = 0;
  num point = 0;
  num quiz = 0;
  num targetNum = 0;
  String? userUID;
  String? userName;
  Stream<QuerySnapshot>? _lectureStream;
  List<DocumentSnapshot> allLectures = [];
  List<DocumentSnapshot> filteredLectures = [];
  int userDay = 0;

  Future<void> fetchLectures() async {
    final QuerySnapshot lectureSnapshot =
    await _firestore.collection('lecture').get();

    setState(() {
      allLectures = lectureSnapshot.docs;
      filteredLectures = allLectures;
    });
  }



  void fetchUser() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        userUID = user.uid;
        userName = user.displayName;
      });
    } else {
      print("Error: User is null");
    }
  }

  void recordUserLoginDate() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userId = user.uid;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('event')
          .doc(userId)
          .get();

      Timestamp? lastLoginTimestamp = userDoc['lastLoginDate'] as Timestamp?;

      if (lastLoginTimestamp != null) {
        DateTime lastLoginDate = lastLoginTimestamp.toDate();

        DateTime currentServerTime = DateTime.now();

        if (currentServerTime.difference(lastLoginDate).inDays == 1) {
          await FirebaseFirestore.instance
              .collection('event')
              .doc(userId)
              .update({'day' : FieldValue.increment(1)});
        } else {
          await FirebaseFirestore.instance
              .collection('event')
              .doc(userId)
              .update({'day' : 1});
        }
      }
      setState(() {
        userDay = userDoc['day'] ?? 0;
        point = userDoc['point'];
        quiz = userDoc['quiz'];
        targetNum = userDoc['targetNumber'];
      });
    }

  }

  @override
  void initState() {
    super.initState();
    fetchUser();
    _startAutoAnimation();
    _lectureStream = _firestore.collection('lecture').snapshots();
    fetchLectures();
    recordUserLoginDate();
  }

  void _startAutoAnimation() {
    _value = 0;
    const duration = Duration(milliseconds: 2);
    Timer.periodic(duration, (timer) {
      setState(() {
        if (_value < point) {
          _value++;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            Text(
              '안녕하세요 $userName님',
              style: GoogleFonts.nanumGothic(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            SearchBarWidget(
              onSearch: (query) {
                setState(() {
                  filteredLectures = allLectures
                      .where((lecture) =>
                      lecture['name'].toLowerCase().contains(query.toLowerCase()))
                      .toList();
                });
              },
            ),
            const SizedBox(
              height: 14,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: CustomColor.yellow,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/u1F4E2.svg',
                      width: 40,
                      height: 40,
                    ),
                    Text(
                      // '$lectureList[] 퀴즈', // 작동할 수 있게 user의 lectureList 항목 개별로 가져올 수 있도록
                      '전공 과목들은 추가 예정입니다',
                      style: GoogleFonts.nanumGothic(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 14,
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              height: 102,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: CustomColor.purple,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Quiz',
                        style: GoogleFonts.russoOne(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: 50,
                        height: 60,
                        child: CircularPercentIndicator(
                          animation: true,
                          animationDuration: 1000,
                          radius: 30,
                          lineWidth: 8,
                          percent: quiz / targetNum,
                          progressColor: CustomColor.brightRed,
                          backgroundColor: Colors.white,
                          circularStrokeCap: CircularStrokeCap.round,
                          center: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$quiz/$targetNum',
                                style: GoogleFonts.nanumGothic(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                              Text(
                                'Quiz played',
                                style: GoogleFonts.nanumGothic(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 5),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 80,
                    child: VerticalDivider(
                      thickness: 0.3,
                      width: 0.82,
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Point',
                        style: GoogleFonts.russoOne(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                        onPressed: _startAutoAnimation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColor.brightRed,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: AnimatedFlipCounter(
                          duration: const Duration(milliseconds: 1000),
                          value: _value,
                          suffix: 'P',
                          textStyle: GoogleFonts.nanumGothic(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 80,
                    child: VerticalDivider(
                      thickness: 0.3,
                      width: 0.82,
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'D+DAY',
                        style: GoogleFonts.russoOne(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                            size: 55,
                          ),
                          Transform.translate(
                            offset: const Offset(0, 4),
                            child: Text(
                              '$userDay',
                              style: GoogleFonts.nanumGothic(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: StreamBuilder<QuerySnapshot>(
                stream: _lectureStream,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Container();
                  }
                  var lectures = snapshot.data!.docs;
                  allLectures = lectures;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 15.0 / 11.0,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                    ),
                    itemCount: filteredLectures.length,
                    itemBuilder: (BuildContext context, int index) {
                      var document = filteredLectures[index];
                      var lectureName = document['name'];
                      var icon = document['iconUrl'];
                      return SizedBox(
                        height: 300,
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                              color: CustomColor.primary,
                              width: 2,
                            ),
                          ),
                          elevation: 0,
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () async {
                              String docID = document['documentID'];
                              String name = document['name'];
                              if (userUID != null) {
                                try {
                                  var userDoc = await _firestore
                                      .collection('user')
                                      .doc(userUID)
                                      .get();
                                  var lectureList =
                                      userDoc['lectureList'] ?? [];
                                  if(!mounted) return;
                                  if (lectureList.contains(docID)) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        backgroundColor: Colors.white,
                                        elevation: 0,
                                        title: const Text('알림'),
                                        content:
                                            Text('이미 수강 목록에 있습니다.',style: GoogleFonts.nanumGothic(
                                              color: Colors.black,
                                            ),),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text('확인',style: GoogleFonts.nanumGothic(
                                              color: Colors.black,
                                            ),),
                                          ),
                                        ],
                                      ),
                                    );
                                    return;
                                  }

                                  // Show the confirmation dialog
                                  // ignore: use_build_context_synchronously
                                  var result = await showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      backgroundColor: Colors.white,
                                      elevation: 0.0,
                                      title: const Text('강의 수강하기'),
                                      content: Text('$name을 수강하시겠습니까?',style: GoogleFonts.nanumGothic(
                                        color: Colors.black,
                                      ),),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, '취소'),
                                          child: Text('취소',style: GoogleFonts.nanumGothic(
                                            color: Colors.black,
                                          ),),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, '확인'),
                                          child: Text('확인',style: GoogleFonts.nanumGothic(
                                            color: Colors.black,
                                          ),),
                                        ),
                                      ],
                                    ),
                                  );

                                  // Check the result and update Firebase if the user clicked 'OK'
                                  if (result == '확인') {
                                    // Update Firebase with the lecture name
                                    await FirebaseFirestore.instance
                                        .collection('user')
                                        .doc(userUID)
                                        .update({
                                      'lectureList':
                                          FieldValue.arrayUnion([docID])
                                    });
                                    await FirebaseFirestore.instance.collection('lecture').doc(docID)
                                        .collection('quiz').doc(userUID)
                                        .set({'wrong' : 0, 'quiz': 0});

                                    // You can add additional logic or UI updates here
                                    print(
                                        'Lecture added to the user\'s lectureList');
                                  }
                                } catch (e) {
                                  print(
                                      'Error checking/updating user document: $e');
                                  // Handle the error as needed
                                }
                              }
                              // userUID 값이 Null일 경우 에러 문 출력 + 로그인 페이지로 이동하기
                              else {
                                print("Error userUID is null!!");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                );
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 7,
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        lectureName,
                                        style: GoogleFonts.russoOne(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        softWrap: true,
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: SvgPicture.network(
                                          icon,
                                          width: 50,
                                          height: 50,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
