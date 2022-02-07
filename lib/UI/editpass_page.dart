import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mytestapp/UI/createjob_page.dart';
import 'package:mytestapp/UI/dashboard_page.dart';
import 'package:mytestapp/UI/logtest_page.dart';
import 'package:mytestapp/UI/setting_page.dart';
import 'package:mytestapp/model/user_model.dart';
import 'package:mytestapp/services/nowdate.dart';

class EditPasswordPage extends StatefulWidget {
  UserModel user;
  EditPasswordPage({Key? key,required this.user}) : super(key: key);

  @override
  _EditPasswordPageState createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  void initState() {
    user = widget.user;
    profile = user;
    setState(() {});

    // TODO: implement initState
    super.initState();
  }

  late UserModel user;
  static UserModel profile = UserModel(
      ID: '',
      Image: '',
      Email: '',
      LineID: '',
      Name: '',
      Password: '',
      Role: '');
  final formKey = GlobalKey<FormState>();

  String newpass = '', conpass = '';
  String url =
      'https://firebasestorage.googleapis.com/v0/b/testdataapp-d6da7.appspot.com/o/profile%2FpersonIcon.jpeg?alt=media&token=f7626bcb-512c-44e6-8aa5-227f543801b4';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Error"),
              ),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: const Color(0xFF025564),
              appBar: AppBar(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      NowDate().datetime(),
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text("Good day!  ${user.Name}"),
                    
                  ],
                ),
                automaticallyImplyLeading: false,
                backgroundColor: const Color(0xFF5E9DA2),
                actions: [
                  CircleAvatar(
                      radius: 20, backgroundImage: NetworkImage(user.Image)),
                  const SizedBox(
                    width: 15,
                  )
                ],
              ),
              body: Form(
                key: formKey,
                child: Container(
                  height: size.height * 1,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: size.height * 0.05,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Edit PassWord",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                          //SizedBox(height: size.height*0.05,),
                        ],
                      ),
                      Container(
                        //color: Colors.white,
                        height: size.height * 0.35,
                        child: Column(
                          children: [
                            SizedBox(height: size.height*0.08,),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "password not null";
                                }
                              },
                              onSaved: (value) =>
                                  setState(() => newpass = value!),
                              decoration: InputDecoration(
                                labelText: "พาสเวิร์ดใหม่",
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                  //fillColor: Colors.white,
                                  //filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                            SizedBox(height: size.height*0.03,),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "password not null";
                                }
                              },
                              onSaved: (value) =>
                                  setState(() => conpass = value!),
                              decoration: InputDecoration(
                                labelText: "ยืนยันพาสเวิร์ด",
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                  //fillColor: Colors.white,
                                  //filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: size.width * 1,
                          height: size.height * 0.08,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  if(newpass == conpass){
                                    print("$newpass = $conpass");
                                    await FirebaseFirestore.instance
                                        .collection("Users")
                                        .doc(user.ID)
                                        .update({
                                      "Password": newpass,
                                    });
                                    user.Password = newpass;
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return SettingPage(
                                        user: user,
                                      );
                                    }));
                                  }
                                  else{print("$newpass != $conpass");}
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: const Color(0xFF00a651), // background
                                onPrimary:
                                    const Color(0xFF00a651), // foreground
                              ),
                              child: const Text(
                                "ใช้รหัสผ่านนี้",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: _DemoBottomAppBar(),
            );
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        });
  }
}

class _DemoBottomAppBar extends StatelessWidget {
  const _DemoBottomAppBar({
    this.fabLocation = FloatingActionButtonLocation.endDocked,
    this.shape = const CircularNotchedRectangle(),
  });

  final FloatingActionButtonLocation fabLocation;
  final NotchedShape? shape;

  static final List<FloatingActionButtonLocation> centerLocations =
      <FloatingActionButtonLocation>[
    FloatingActionButtonLocation.centerDocked,
    FloatingActionButtonLocation.centerFloat,
  ];

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: shape,
      color: const Color(0xFF5E9DA2),
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  var profile = _EditPasswordPageState.profile;
                  return DashboardPage(
                    user: profile,
                  );
                }));
              },
            ),
            if (centerLocations.contains(fabLocation)) const Spacer(),
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  var profile = _EditPasswordPageState.profile;
                  return CreateJobPage(
                    user: profile,
                  );
                }));
              },
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today_rounded),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  var profile = _EditPasswordPageState.profile;
                  return LogTestPage(
                    user: profile,
                  );
                }));
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings,color: Colors.yellow),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  var profile = _EditPasswordPageState.profile;
                  return SettingPage(
                    user: profile,
                  );
                }));
              },
            ),
          ],
        ),
      ),
    );
  }
}
