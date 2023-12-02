import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'color/color.dart';

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

  @override
  void initState() {
    super.initState();
    fetchDataFromFirestore();
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

  void onNextQuestionPressed() {
    if (currentQuestionIndex < quizData.length - 1) {
      setState(() {
        currentQuestionIndex++;
        _selectedChoiceIndex = -1;
      });
    } else {
      // Handle quiz completion or navigate to the next screen.
      Navigator.pushNamed(context, '/home');
    }
  }
  void onPreviousQuestionPressed() {
    if (currentQuestionIndex >= 0) {
      setState(() {
        currentQuestionIndex--;
      });
    } else {
      // Handle quiz completion or navigate to the next screen.
    }
  }

  bool showAnswer(int selectedChoiceIndex) {
    // Get the correct answer index for the current question
    int correctAnswerIndex =
    quizData[currentQuestionIndex]['correctAnswerIndex'];

    // Check if the selected choice index is equal to the correct answer index
    bool isCorrect = selectedChoiceIndex == correctAnswerIndex;

    // Show an alert based on whether the answer is correct
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isCorrect ? 'Correct!' : 'Incorrect!'),
          content: Text(
            isCorrect
                ? 'Congratulations! You chose the correct answer.'
                : 'Oops! You chose the incorrect answer.',
          ),
          actions: [
            isCorrect
                ? TextButton(
              onPressed: () {
                // Move to the next question or handle quiz completion
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            )
                : TextButton(
              onPressed: () {
                // Move to the next question or handle quiz completion
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
    return isCorrect ? true : false;
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
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.bookmark_outline_rounded,size: 35,color: CustomColor.brightRed,)),
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
        actions: [
          ElevatedButton(
            onPressed: onNextQuestionPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff001C9C),
            ),
            child: Text(
              '넘기기',
              style: GoogleFonts.nanumGothic(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          )
        ],
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
              height: 550,
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                ),
                child: Column(
                  children: [
                    Text('문제 ${currentQuestionIndex + 1}',style: GoogleFonts.nanumGothic(
                        fontSize: 20, fontWeight: FontWeight.bold),),
                    Text(
                      quizData.isNotEmpty
                          ? quizData[currentQuestionIndex]['questionText']
                          : '',
                      style: GoogleFonts.nanumGothic(
                          fontSize: 25, fontWeight: FontWeight.bold),
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
                                child: Text(
                                  quizData[currentQuestionIndex]['choices'][index],
                                  style: GoogleFonts.nanumGothic(
                                    fontSize: 23,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0.0,
                            backgroundColor: Colors.white,
                            textStyle: GoogleFonts.nanumGothic(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: onPreviousQuestionPressed
                          ,
                          child: Text(
                            '이전',
                            style: GoogleFonts.nanumGothic(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
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
                          onPressed: () {
                            if(showAnswer(_selectedChoiceIndex) == true) {
                              onNextQuestionPressed();
                            }
                            else {
                            }
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
