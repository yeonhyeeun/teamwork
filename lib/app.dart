import 'package:flutter/material.dart';
import 'package:teamwork/model/lecture.dart';
import 'package:teamwork/nav.dart';
import 'login.dart';

class StudyJoyApp extends StatefulWidget {
  const StudyJoyApp({Key? key}) : super(key: key);
  @override
  State<StudyJoyApp> createState() => _StudyJoyAppState();
}

class _StudyJoyAppState extends State<StudyJoyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudyJoy',
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => LoginPage(),
        '/home': (BuildContext context) => BottomNavigation(),
      },
    );
  }
}

class StudyJoyAppState extends ChangeNotifier {
  var favorites = <Lecture>[];
  void tappedFavorite(Lecture lecture) {
    if(favorites.contains(lecture)) {
      favorites.remove(lecture);
    }
    else {
      favorites.add(lecture);
    }
    notifyListeners();
  }
  void removedFavorite(Lecture lecture) {
    favorites.remove(lecture);
    notifyListeners();
  }



}