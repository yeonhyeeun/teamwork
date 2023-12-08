import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teamwork/color/color.dart';

class AddQuestionPage extends StatefulWidget {
  @override
  _AddQuestionPageState createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  TextEditingController questionTextController = TextEditingController();
  TextEditingController choicesController = TextEditingController();
  TextEditingController correctAnswerIndexController = TextEditingController();
  List<TextEditingController> choicesControllers = [TextEditingController()];
  bool isImageLoaded = false;

  XFile? _image; //이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화
  String scannedText = ""; // textRecognizer로 인식된 텍스트를 담을 String

  //이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
        isImageLoaded = true;
      });
      getRecognizedText(_image!); // 이미지를 가져온 뒤 텍스트 인식 실행
    }
  }

  void getRecognizedText(XFile image) async {
    // XFile 이미지를 InputImage 이미지로 변환
    final InputImage inputImage = InputImage.fromFilePath(image.path);

    final textRecognizer =
    GoogleMlKit.vision.textRecognizer(script: TextRecognitionScript.korean);

    // 이미지의 텍스트 인식해서 recognizedText에 저장
    RecognizedText recognizedText =
    await textRecognizer.processImage(inputImage);

    // Release resources
    await textRecognizer.close();

    // 인식한 텍스트 정보를 scannedText에 저장
    scannedText = "";
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = "$scannedText${line.text}\n";
      }
    }
    questionTextController.text = scannedText;


    setState(() {});
  }

  Widget buildChoiceItem(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Checkbox(
            activeColor: CustomColor.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            value: index == (int.tryParse(correctAnswerIndexController.text) ?? -1),
            onChanged: (bool? value) {
              setState(() {
                correctAnswerIndexController.text = value! ? index.toString() : "";
              });
            },
          ),
          Expanded(
            child: TextField(
              onTapOutside: (event) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              controller: choicesControllers[index],
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: CustomColor.primary,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: CustomColor.primary,
                    width: 2,
                  ),
                ),
                hintText: '보기 ${index + 1}',
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                choicesControllers.removeAt(index);
              });
            },
            icon: Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColor.primary,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          '객관식 문제 만들기',
          style: GoogleFonts.nanumGothic(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: CustomColor.primary,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: 400,
          height: screenSize.height,
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(40),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 15,),
                  _buildButton(),
                  SizedBox(height: 15,),
                  TextField(
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    maxLines: 3,
                    controller: questionTextController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: CustomColor.primary, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: CustomColor.primary, width: 2),
                      ),
                      hintText: '문제',
                    ),
                  ),
                  SizedBox(height: 10,),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: choicesControllers.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index < choicesControllers.length) {
                          // Choices TextFields
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                            child: CheckboxListTile(
                              activeColor: CustomColor.primary,
                              checkboxShape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              title: TextField(
                                onTapOutside: (event) =>
                                    FocusManager.instance.primaryFocus?.unfocus(),
                                controller: choicesControllers[index],
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: CustomColor.primary,
                                      width: 2,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: CustomColor.primary,
                                      width: 2,
                                    ),
                                  ),
                                  hintText: '보기 ${index + 1}',
                                ),
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: index == (int.tryParse(correctAnswerIndexController.text) ?? -1),
                              onChanged: (bool? value) {
                                setState(() {
                                  correctAnswerIndexController.text = value! ? index.toString() : "";
                                });
                              },
                            ),
                          );
                        } else {
                          // IconButton
                          return Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    choicesControllers.add(TextEditingController());
                                  });
                                },
                                icon: Icon(Icons.add_circle_outline, color: CustomColor.primary, size: 30,),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  addQuestionToFirestore(context);
                                },

                                child: Text('저장',style: GoogleFonts.nanumGothic(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),),
                                style: ElevatedButton.styleFrom(
                                    elevation: 0.0,
                                    minimumSize: Size(120,50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.zero,
                                    backgroundColor: CustomColor.red,
                                    textStyle: GoogleFonts.nanumGothic(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addQuestionToFirestore(BuildContext context) async {
    try {
      // Convert choices to a List<String>
      List<String> choices = choicesControllers.map((controller) => controller.text).toList();

      // Try parsing correctAnswerIndexController.text to an integer
      int? correctAnswerIndex = int.tryParse(correctAnswerIndexController.text);

      if (correctAnswerIndex == null) {
        // Handle the case where correctAnswerIndexController.text is not a valid number
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('정답 혹은 문제를 입력하세요!'),
          ),
        );
        return;
      }

      // Create a map for the question
      Map<String, dynamic> questionMap = {
        'questionText': questionTextController.text,
        'choices': choices,
        'correctAnswerIndex': correctAnswerIndex,
      };

      // Replace 'lectures' with your collection name.
      var collectionReference = FirebaseFirestore.instance.collection('lecture');

      // Replace 'your_document_id' with the actual document ID.
      var documentReference = collectionReference.doc('QB6YGJCNSNa7FdTfWnYe');

      // Update the Firestore document with the new question.
      await documentReference.update({'questions': FieldValue.arrayUnion([questionMap])});

      // Clear text controllers after adding the question.
      questionTextController.clear();
      choicesControllers.forEach((controller) => controller.clear());
      correctAnswerIndexController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('문제 등록하기 성공!'),
        ),
      );
    } catch (e) {
      print('Error adding question to Firestore: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('문제 등록 중 오류가 발생했습니다.'),
        ),
      );
    }
  }



  Widget _buildButton() {
    return DottedBorder(
      radius: const Radius.circular(50),
      dashPattern: [6, 3],
      strokeWidth: 1,
      color: Colors.grey,
      borderType: BorderType.Rect,
      child: Container(
        height: 200,
        width: 360,
        child: Center(
          child: isImageLoaded
              ? Image.file(
            File(_image!.path),
            width: 400,
            height: 200,
            fit: BoxFit.fill,
          )
              : Container(
            width: 120,
            height: 30,
            child: OutlinedButton.icon(
              onPressed: () {
                getImage(ImageSource.gallery);
              },
              icon: Icon(
                Icons.photo_camera_outlined,
                size: 15.0,
                color: Colors.grey,
              ),
              label: Text(
                'upload',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


void main() {
  runApp(
    MaterialApp(
      home: AddQuestionPage(),
    ),
  );
}
