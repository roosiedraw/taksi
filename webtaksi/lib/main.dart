import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:webtaksi/panel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyDKOWgCjXRmkF8Fe5sli8OT3LPO4RRSrRM",
          authDomain: "taksi-3a8ce.firebaseapp.com",
          projectId: "taksi-3a8ce",
          storageBucket: "taksi-3a8ce.appspot.com",
          messagingSenderId: "648286966791",
          appId: "1:648286966791:web:24e1f995c75fabad6806a2",
          measurementId: "G-Y60LVQC614"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Panel());
  }
}
