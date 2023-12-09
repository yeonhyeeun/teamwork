import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';

import 'color/color.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final CarouselController _carouselController = CarouselController();
  String? userUID;
  String? userName;
  String? selectedMajor;
  int _currentPage = 0;

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

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CarouselSlider(
              carouselController: _carouselController,
              items: [
                majorPage(),
                questionPage(),
              ],
              options: CarouselOptions(
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                height: 300.0,
                enlargeCenterPage: true,
                autoPlay: false,
                enableInfiniteScroll: false,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(2, (index) {
                return Container(
                  width: 10.0,
                  height: 10.0,
                  margin: EdgeInsets.symmetric(horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? Colors.blue : Colors.grey,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget majorPage() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '전공을 선택해주세요',
            style: GoogleFonts.nanumGothic(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: selectedMajor,
            onChanged: (String? newValue) {
              setState(() {
                selectedMajor = newValue;
              });
            },
            dropdownColor: Colors.white,
            decoration: InputDecoration(
              hintText: '전공',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
              enabledBorder: GradientOutlineInputBorder(
                gradient: LinearGradient(colors: [CustomColor.primary, Colors.blue]),
                width: 2,
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: GradientOutlineInputBorder(
                gradient: LinearGradient(colors: [CustomColor.primary, Colors.purple]),
                width: 2,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            items: <String>[
              '글로벌리더쉽학부', '국제어문학부','경영경제학부'
              ,'법학부','커뮤니케이션학부','공간환경시스템공학부'
              ,'기계제어공학부','콘텐츠융합디자인학부','생명과학부'
              ,'전산전자공학부','상담심리사회복지학부','ICT창업학부'
            ]
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          Container(
            width: 90,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                if (selectedMajor != null && userUID != null) {
                  await FirebaseFirestore.instance
                      .collection('user')
                      .doc(userUID!)
                      .update({'major': selectedMajor!});
                  await FirebaseFirestore.instance
                      .collection('user')
                      .doc(userUID!)
                      .collection('login')
                      .doc(userUID!)
                      .set({'addAccount': true});
                  _carouselController.nextPage(duration: Duration(milliseconds: 10));
                } else {
                  Fluttertoast.showToast(
                    msg: "전공을 선택해주세요!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.zero,
                backgroundColor: CustomColor.brightRed,
                textStyle: GoogleFonts.nanumGothic(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text(
                '다음',
                style: GoogleFonts.nanumGothic(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget questionPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '풀 문제 수를 입력해주세요',
          style: GoogleFonts.nanumGothic(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: TextField(
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            controller: _textEditingController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
              enabledBorder: GradientOutlineInputBorder(
                gradient:
                LinearGradient(colors: [CustomColor.primary, Colors.blue]),
                width: 2,
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: GradientOutlineInputBorder(
                gradient:
                LinearGradient(colors: [CustomColor.primary, Colors.purple]),
                width: 2,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Container(
          width: 90,
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              if (_textEditingController.text.isNotEmpty && userUID != null) {
                await FirebaseFirestore.instance
                    .collection('event')
                    .doc(userUID!)
                    .update(
                    {'targetNumber': int.parse(_textEditingController.text)});
                await FirebaseFirestore.instance
                    .collection('user')
                    .doc(userUID!)
                    .collection('login')
                    .doc(userUID!)
                    .set({'addAccount': true});
                Navigator.pushNamed(context, '/home');
              } else {
                Fluttertoast.showToast(
                  msg: "숫자를 입력해주세요!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }
            },
            style: ElevatedButton.styleFrom(
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.zero,
                backgroundColor: CustomColor.brightRed,
                textStyle: GoogleFonts.nanumGothic(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            child: Text(
              '다음',
              style: GoogleFonts.nanumGothic(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

