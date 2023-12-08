import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:teamwork/color/color.dart';



class QuizPage extends StatefulWidget {
  final String lectureId;

  const QuizPage({Key? key, required this.lectureId}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late List<Map<dynamic, dynamic>> quizData = [];
  int currentQuestionIndex = 0;
  int _selectedChoiceIndex = -1;
  String? userUID;

  @override
  void initState() {
    super.initState();
    fetchDataFromFirestore();
    fetchUser();
  }

  void fetchUser(){
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userUID = user.uid;
      });
    }
  }

  Future<void> fetchDataFromFirestore() async {
    //quizData가 비어있을때만
    if (quizData.isEmpty) {
      try {
        var snapshot = await FirebaseFirestore.instance
            .collection('lecture')
            .doc(widget.lectureId)
            .get();

        List<Map<dynamic, dynamic>> fetchedQuizData =
        List<Map<dynamic, dynamic>>.from(snapshot['questions']);

        setState(() {
          quizData = fetchedQuizData;
        });
      } catch (e) {
        print('Error fetching data from Firestore: $e');
      }
    }
  }

  Future<void> onNextQuestionPressed() async {
    if (currentQuestionIndex < quizData.length - 1) {
      bool isCorrect = await showAnswer(_selectedChoiceIndex);

        setState(() {
          currentQuestionIndex++;
          _selectedChoiceIndex = -1;
        });
    } else {
      // Handle quiz completion or navigate to the next screen.
      bool isCorrect = await showAnswer(_selectedChoiceIndex);

        Navigator.pushNamed(context, '/home');

    }
  }


  Future<bool> showAnswer(int selectedChoiceIndex) async {
    User? user = FirebaseAuth.instance.currentUser;

    int correctAnswerIndex = quizData[currentQuestionIndex]['correctAnswerIndex'];
    bool isCorrect = selectedChoiceIndex == correctAnswerIndex;

    if (user != null) {
      if (isCorrect) {
        Fluttertoast.showToast(
          msg: "정답입니다!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.lightBlueAccent,
          textColor: Colors.black,
          fontSize: 16.0,
        );
        await FirebaseFirestore.instance.collection('lecture').doc(widget.lectureId)
            .collection('quiz').doc(userUID)
            .update({'number' : FieldValue.increment(1)});
        await FirebaseFirestore
            .instance.collection('event')
            .doc(userUID)
            .update({'point' : FieldValue.increment(10)});
        await FirebaseFirestore
            .instance.collection('event')
            .doc(userUID)
            .update({'quiz' : FieldValue.increment(1)});
      } else {
        Fluttertoast.showToast(
          msg: "오답입니다!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        await FirebaseFirestore.instance.collection('lecture').doc(widget.lectureId)
            .collection('quiz').doc(userUID)
            .update({'wrong' : FieldValue.increment(1)});
        await FirebaseFirestore
            .instance.collection('event')
            .doc(userUID)
            .update({'quiz' : FieldValue.increment(1)});
      }

    }
    return isCorrect;
  }

  void onAnswerSelected(int selectedChoiceIndex) {
    setState(() {
      _selectedChoiceIndex = selectedChoiceIndex;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.primary,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.bookmark_outline_rounded,color: CustomColor.brightRed,size: 35,))],
        title: Text(
          '${currentQuestionIndex + 1} of ${quizData.length}',
          style: GoogleFonts.nanumGothic(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: CustomColor.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LinearPercentIndicator(
              alignment: MainAxisAlignment.center,
              animation: true,
              barRadius: Radius.circular(20),
              padding: EdgeInsets.zero,
              percent: quizData.isNotEmpty
                  ? (currentQuestionIndex + 1) / quizData.length.toDouble()
                  : 0.0, // 수정된 부분
              lineHeight: 10,
              backgroundColor: Colors.white,
              progressColor: CustomColor.brightRed,
              width: 340,
            ),
            SizedBox(height: 10,),
            Container(
              width: 400,
              height: 600,
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 15,),
                    // 문제 지문
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 33.0,vertical: 10),
                      child: Text(
                        quizData.isNotEmpty
                            ? quizData[currentQuestionIndex]['questionText']
                            : '',
                        style: GoogleFonts.nanumGothic(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...(quizData.isNotEmpty
                        ? List.generate(
                      quizData[currentQuestionIndex]['choices'].length,
                          (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: GestureDetector(
                          onTap: () {
                            onAnswerSelected(index);
                          },

                          child: SizedBox(
                            height: 70, // Adjust the height as needed
                            child: Container(
                              width: 320,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _selectedChoiceIndex == index ? Colors.green : Colors.black,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                // 문제 선지
                                child: Text(
                                  quizData[currentQuestionIndex]['choices'][index],
                                  style: GoogleFonts.nanumGothic(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                        : []),
                    SizedBox(height: 20,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(120,50),
                        elevation: 0.0,
                        backgroundColor: CustomColor.brightRed,
                        textStyle: GoogleFonts.nanumGothic(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        await onNextQuestionPressed();
                      },
                      child: Text(
                        '다음',
                        style: GoogleFonts.nanumGothic(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
