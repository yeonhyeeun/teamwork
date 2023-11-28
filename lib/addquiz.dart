import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddQuestionPage extends StatefulWidget {
  @override
  _AddQuestionPageState createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  TextEditingController questionTextController = TextEditingController();
  TextEditingController choicesController = TextEditingController();
  TextEditingController correctAnswerIndexController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Question'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: questionTextController,
              decoration: InputDecoration(labelText: 'Question Text'),
            ),
            TextField(
              controller: choicesController,
              decoration: InputDecoration(labelText: 'Choices (comma-separated)'),
            ),
            TextField(
              controller: correctAnswerIndexController,
              decoration: InputDecoration(labelText: 'Correct Answer Index'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                addQuestionToFirestore();
              },
              child: Text('Add Question to Firestore'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addQuestionToFirestore() async {
    try {
      // Convert choices to a List<String>
      List<String> choices = choicesController.text.split(',');

      // Create a map for the question
      Map<String, dynamic> questionMap = {
        'questionText': questionTextController.text,
        'choices': choices,
        'correctAnswerIndex': int.parse(correctAnswerIndexController.text),
      };

      // Replace 'lectures' with your collection name.
      var collectionReference = FirebaseFirestore.instance.collection('lecture');

      // Replace 'your_document_id' with the actual document ID.
      var documentReference = collectionReference.doc('QB6YGJCNSNa7FdTfWnYe');

      // Update the Firestore document with the new question.
      await documentReference.update({'questions': FieldValue.arrayUnion([questionMap])});

      // Clear text controllers after adding the question.
      questionTextController.clear();
      choicesController.clear();
      correctAnswerIndexController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Question added to Firestore'),
        ),
      );
    } catch (e) {
      print('Error adding question to Firestore: $e');
    }
  }
}

void main() {
  runApp(
    MaterialApp(
      home: AddQuestionPage(),
    ),
  );
}
