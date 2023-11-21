import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
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

  @override
  void initState() {
    super.initState();
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
        physics: AlwaysScrollableScrollPhysics(),
        // Set physics to AlwaysScrollableScrollPhysics
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Text(
                '안녕하세요 홍길동님',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SearchBarWidget(),
            SizedBox(
              height: 14,
            ),
            Container(
              margin: EdgeInsets.symmetric(
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
                  Icon(
                    Icons.computer,
                    size: 40,
                  ),
                  Text(
                    '컴퓨터 네트워크 퀴즈',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('이어서'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColor.brightRed,
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 14,
            ),
            Container(
              margin: EdgeInsets.symmetric(
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
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
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
                          center: Column(
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
                  Container(
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
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                        onPressed: _startAutoAnimation,
                        child: AnimatedFlipCounter(
                          duration: Duration(milliseconds: 1000),
                          value: _value,
                          suffix: 'P',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColor.brightRed,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
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
                stream:
                    FirebaseFirestore.instance.collection('lecture').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator(); // Loading indicator
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text(
                        'No data available'); // You can replace this with an appropriate message or widget.
                  }
                  var lectures = snapshot.data!.docs;

                  return GridView.builder(
                    shrinkWrap: true,
                    // Set shrinkWrap to true
                    physics: NeverScrollableScrollPhysics(),
                    // Set physics to NeverScrollableScrollPhysics
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 15.0 / 10.0,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                    ),
                    itemCount: lectures.length,
                    itemBuilder: (BuildContext context, int index) {
                      var document = snapshot.data!.docs[index];
                      var lectureName = document['name'];
                      return Container(
                        height: 300,
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
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
                                      style: TextStyle(
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
