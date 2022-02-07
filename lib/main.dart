import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mytestapp/UI/createjob_page.dart';
import 'package:mytestapp/UI/editpass_page.dart';
import 'package:mytestapp/UI/editprofile_page.dart';
import 'package:mytestapp/UI/jobdetail_page.dart';
import 'package:mytestapp/UI/log_page.dart';
import 'package:mytestapp/UI/login_page.dart';
import 'package:mytestapp/UI/logtest_page.dart';
import 'package:mytestapp/UI/setting_page.dart';
import 'package:mytestapp/UI/signup_page.dart';
import 'package:mytestapp/UI/teamselectleader.dart';
import 'package:mytestapp/UI/teamselectmember.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      //home: TestPage(),
      home: LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
