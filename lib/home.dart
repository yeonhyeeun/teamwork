import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:teamwork/login.dart';
import 'package:teamwork/search.dart';
import 'color/color.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  num _value = 0;
  num point = 200;
  String? userUID;
  String? userName;

  void fetchUser() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        userUID = user.uid;
        userName = user.displayName;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
    _startAutoAnimation();
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
        // Set physics to AlwaysScrollableScrollPhysics
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Text(
                '안녕하세요 ${userName}님',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SearchBarWidget(),
            const SizedBox(
              height: 14,
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              height: 85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: CustomColor.yellow,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(
                    Icons.computer,
                    size: 40,
                  ),
                  const Text(
                    '컴퓨터 네트워크 퀴즈',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColor.brightRed,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    child: const Text('이어서'),
                  ),
                ],
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
                      const Text(
                        'Quiz',
                        style: TextStyle(color: Colors.white),
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
                          percent: 37 / 50,
                          progressColor: CustomColor.brightRed,
                          backgroundColor: Colors.white,
                          circularStrokeCap: CircularStrokeCap.round,
                          center: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '37/50',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Quiz played',
                                style: TextStyle(
                                  fontSize: 6,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
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
                      const Text(
                        'Point',
                        style: TextStyle(color: Colors.white),
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
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'D+DAY',
                        style: TextStyle(color: Colors.white),
                      ),
                      Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                            size: 55,
                          ),
                          Text(
                            '7',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
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
                stream: FirebaseFirestore.instance
                    .collection('lecture')
                    .snapshots(),
                //FirebaseFirestore.instance
                //       .collection('lecture')
                //       .select(['name']) // 필요한 필드만 선택
                //       .snapshots()
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator(); // Loading indicator
                  }

                  var lectures = snapshot.data!.docs;

                  return GridView.builder(
                    shrinkWrap: true,
                    // Set shrinkWrap to true
                    physics: const NeverScrollableScrollPhysics(),
                    // Set physics to NeverScrollableScrollPhysics
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 15.0 / 10.0,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                    ),
                    itemCount: lectures.length,
                    itemBuilder: (BuildContext context, int index) {
                      var document = lectures[index];
                      var lectureName = document['name'];
                      return InkWell(
                        onTap: () async {
                          String lectureName = document['name'];
                          // Check if the lectureName is already in the lectureList
                          if (userUID != null) {
                            try {
                              var userDoc = await FirebaseFirestore.instance
                                  .collection('user')
                                  .doc(userUID)
                                  .get();
                              var lectureList = userDoc['lectureList'] ?? [];

                              if (lectureList.contains(lectureName)) {
                                // The lecture is already in the list, show an alert
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('알림'),
                                    content: Text(
                                        '$lectureName 과목은 이미 수강 목록에 있습니다.'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('확인'),
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
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('강의 수강하기'),
                                  content: Text('$lectureName을 수강하시겠습니까?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'OK'),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );

                              // Check the result and update Firebase if the user clicked 'OK'
                              if (result == 'OK') {
                                // Update Firebase with the lecture name
                                await FirebaseFirestore.instance
                                    .collection('user')
                                    .doc(userUID)
                                    .update({
                                  'lectureList':
                                      FieldValue.arrayUnion([lectureName])
                                });

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
                              MaterialPageRoute(builder: (context) => LoginPage()),
                            );
                          }
                        },
                        child: SizedBox(
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
                            elevation: 4,
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16.0,
                                    12.0,
                                    16.0,
                                    10,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        lectureName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
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
