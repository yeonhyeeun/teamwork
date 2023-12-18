import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'settings/app.dart';
import 'settings/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => StudyJoyAppState(),
      child:  StudyJoyApp(),
    ),
  );
}
