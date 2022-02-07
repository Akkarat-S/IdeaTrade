import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mytestapp/UI/createjob_page.dart';
import 'package:mytestapp/UI/logtest_page.dart';
import 'package:mytestapp/UI/setting_page.dart';
import 'package:mytestapp/model/user_model.dart';
import 'package:mytestapp/services/nowdate.dart';

import 'dashboard_page.dart';

class EditProfilePage extends StatefulWidget {
  UserModel user;
  EditProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  void initState() {
    user = widget.user;
    profile = user;
    setState(() {
      url = user.Image;
      nameE = user.Name;
      txtconname.text = nameE;
    });

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
  final txtconname = TextEditingController();
  String nameE = 'EditName';

  String name = 'name', line = 'line', mail = 'mail';
  String url =
      'https://firebasestorage.googleapis.com/v0/b/testdataapp-d6da7.appspot.com/o/profile%2FpersonIcon.jpeg?alt=media&token=f7626bcb-512c-44e6-8aa5-227f543801b4';

  String newUrl = '';
  File? file;
  String pathImage = '';
  late Future<File> imageFile;
  Future uploadFile() async {
    if (file == null) return;
    final fileName = file!.path;
    final destination = 'images/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(destination);
      await ref.putFile(file!);
      String url;
      url = (await ref.getDownloadURL()).toString();
      print("URL:$url");
      newUrl = url;
    } catch (e) {
      print('error occured');
    }
  }

  getImage(ImageSource source) async {
    try {
      var result = await ImagePicker()
          .getImage(source: source, maxWidth: 800, maxHeight: 800);
      file = await File(result!.path);
      //editprofile.Image = File(result!.path);
    } catch (e) {}
    setState(() {
      print("Image:$file");
      pathImage = file.toString();
    });
    //setState(() {});
  }

  Container ImageShow() {
    if (pathImage != '') {
      return Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 1,
          //color: const Color(0xFF5E9DA2),
          child: Image.file(file!));
    }
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width * 1,
      //color: const Color(0xFF5E9DA2),
      child: CircleAvatar(
          radius: (MediaQuery.of(context).size.height * 0.12),
          backgroundImage: NetworkImage(url)),
    );
  }

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
                            height: size.height * 0.04,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Edit Profile",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ImageShow(),
                      Container(
                        //color: Colors.white,
                        height: size.height * 0.35,
                        child: Column(
                          children: [
                            IconButton(
                                onPressed: () {
                                  getImage(ImageSource.gallery);
                                },
                                icon: const Icon(
                                    Icons.add_photo_alternate_rounded)),
                            TextFormField(
                              controller: txtconname,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "name not null";
                                }
                              },
                              onSaved: (value) =>
                                  setState(() => nameE = value!),
                              decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
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
                          height: size.height * 0.07,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  if (pathImage != '') {
                                    await uploadFile();
                                    await FirebaseFirestore.instance
                                        .collection("Users")
                                        .doc(user.ID)
                                        .update({
                                      "Name": nameE,
                                      "Image": newUrl,
                                    });
                                    user.Name = nameE;
                                    user.Image = newUrl;
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return SettingPage(
                                        user: user,
                                      );
                                    }));
                                  } else {
                                    await FirebaseFirestore.instance
                                        .collection("Users")
                                        .doc(user.ID)
                                        .update({
                                      "Name": nameE,
                                    });
                                    user.Name = nameE;
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return SettingPage(
                                        user: user,
                                      );
                                    }));
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: const Color(0xFF00a651), // background
                                onPrimary:
                                    const Color(0xFF00a651), // foreground
                              ),
                              child: const Text(
                                "OK",
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
                  var profile = _EditProfilePageState.profile;
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
                  var profile = _EditProfilePageState.profile;
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
                  var profile = _EditProfilePageState.profile;
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
                  var profile = _EditProfilePageState.profile;
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
