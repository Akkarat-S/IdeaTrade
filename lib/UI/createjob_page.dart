import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mytestapp/UI/dashboard_page.dart';
import 'package:mytestapp/UI/logtest_page.dart';
import 'package:mytestapp/UI/setting_page.dart';
import 'package:mytestapp/UI/teamselectleader.dart';
import 'package:mytestapp/model/user_model.dart';
import 'package:mytestapp/services/nowdate.dart';

class CreateJobPage extends StatefulWidget {
  UserModel user;
  //JobModel job;
  CreateJobPage({Key? key, required this.user}) : super(key: key);

  @override
  _CreateJobPageState createState() => _CreateJobPageState();
}

class _CreateJobPageState extends State<CreateJobPage> {
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference job = FirebaseFirestore.instance.collection("Jobs");

  late UserModel user;
  static UserModel profile = UserModel(
      ID: '',
      Image: '',
      Email: '',
      LineID: '',
      Name: '',
      Password: '',
      Role: '');

  @override
  void initState() {
    user = widget.user;
    profile = user;
    //job = widget.job;
    FirebaseFirestore.instance
        .collection("Teams")
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.forEach((document) {
                setState(() {
                  //print("Name:${document.id}");
                  lsteam.add(document['TeamName']);
                });
              })
            });
    // TODO: implement initState
    super.initState();
  }

  final formKey = GlobalKey<FormState>();
  List<String> lsteam = ['New Team'];
  List<String> lstime = ['10 Minute', '15 Minute', '20 Minute', '30 Minute', '60 Minute'];

  //late UserModel user;
  //late JobModel job;
  late String URL;
  File? file;
  String pathImage = '';
  late Future<File> imageFile;
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
      URL = url;
    } catch (e) {
      print('error occured');
    }
  }

  Container _addImage() {
    if (pathImage == '') {
      return Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.8,
        child: IconButton(
            onPressed: () {
              getImage(ImageSource.gallery);
            },
            icon: const Icon(Icons.add_circle)),
      );
    }
    return Container(
      //color: Colors.white,
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Image.file(
        file!,
      ),
    );
  }

  String valueteam = "Select Team";
  String valuetime = "Select Time";

  late String subject, note;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
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
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.015,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: size.width * 0.2,
                            child: const Text(
                              "Team",
                              style: TextStyle(color: Colors.yellow),
                            )),
                        SizedBox(
                          width: size.width * 0.7,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Center(
                                child: DropdownButton(
                                  hint: Text(
                                    valueteam,
                                    //style: const TextStyle(color: Colors.white)
                                  ),
                                  items:
                                      lsteam.map((String dropDownStringItem) {
                                    return DropdownMenuItem<String>(
                                      value: dropDownStringItem,
                                      child: Text(dropDownStringItem),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      if (newValue == 'New Team') {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return TeamSelectLeader(
                                            user: user,
                                          );
                                        }));
                                      }
                                      print(newValue);
                                      valueteam = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: size.width * 0.2,
                            child: const Text("Subject",
                                style: TextStyle(color: Colors.yellow))),
                        Container(
                            width: size.width * 0.7,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "subject not null";
                                  }
                                },
                                onSaved: (value) =>
                                    setState(() => subject = value!),
                                decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                              ),
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: size.width * 0.2,
                            child: const Text(
                              "Time",
                              style: TextStyle(color: Colors.yellow),
                            )),
                        SizedBox(
                          width: size.width * 0.7,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Center(
                                child: DropdownButton(
                                  hint: Text(
                                    valuetime,
                                    //style: const TextStyle(color: Colors.white)
                                  ),
                                  //value: "Select Team",
                                  items:
                                      lstime.map((String dropDownStringItem) {
                                    return DropdownMenuItem<String>(
                                      value: dropDownStringItem,
                                      child: Text(dropDownStringItem),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      print(newValue);
                                      valuetime = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    _addImage(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onSaved: (value) => setState(() => note = value!),
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: size.width * 0.2,
                        ),
                        InkWell(
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              DateTime _now = DateTime.now();
                              String date =
                                  '${_now.day}/${_now.month}/${_now.year} ${_now.hour}:${_now.minute}';
                              print(date);
                              formKey.currentState!.save();
                              if (pathImage != '') {
                                if (valueteam != 'Select Team') {
                                  if (valuetime != "Select Time") {
                                    print(
                                        "Team:$valueteam\nSubject:$subject\nTime:$valuetime\nImage:$pathImage\nNote:$note");
                                    await uploadFile();
                                    job.doc().set({
                                      "JobTeam": valueteam,
                                      "Subject": subject,
                                      "Time": valuetime,
                                      "Note": note,
                                      "JobImage": URL,
                                      "CreaterID": user.ID,
                                      "Recive": "",
                                      "Status": "Waiting",
                                      "DateTime": date,
                                      "DateTimeLimit": '',
                                      "Reason": '',
                                    });
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return DashboardPage(
                                        user: user,
                                      );
                                    }));
                                  } else {
                                    print("Time not Select");
                                  }
                                } else {
                                  print("Team not Select");
                                }
                              } else {
                                if (valueteam != 'Select Team') {
                                  if (valuetime != "Select Time") {
                                    print(
                                        "Team:$valueteam\nSubject:$subject\nTime:$valuetime\nImage:$pathImage\nNote:$note");
                                    job.doc().set({
                                      "JobTeam": valueteam,
                                      "Subject": subject,
                                      "Time": valuetime,
                                      "Note": note,
                                      "JobImage": "",
                                      "CreaterID": user.ID,
                                      "Recive": "",
                                      "Status": "Waiting",
                                      "DateTime": date,
                                      "DateTimeLimit": '',
                                      "Reason": '',
                                    });
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return DashboardPage(
                                        user: user,
                                      );
                                    }));
                                  } else {
                                    print("Time not Select");
                                  }
                                } else {
                                  print("Team not Select");
                                }
                              }
                            }
                          },
                          child: Container(
                            height: size.height * 0.06,
                            width: size.width * 0.2,
                            decoration: const BoxDecoration(
                                color: Colors.green,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: const Center(
                                child: Text(
                              "OK",
                              style: TextStyle(color: Colors.white),
                            )),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.2,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              pathImage = '';
                              valueteam = "Select Team";
                              valuetime = "Select Time";
                            });
                          },
                          child: Container(
                            height: size.height * 0.06,
                            width: size.width * 0.2,
                            decoration: const BoxDecoration(
                                color: Colors.red,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: const Center(
                                child: Text(
                              "Reset",
                              style: TextStyle(color: Colors.white),
                            )),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.2,
                        ),
                      ],
                    ),
                  ],
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
                  var profile = _CreateJobPageState.profile;
                  return DashboardPage(
                    user: profile,
                  );
                }));
              },
            ),
            if (centerLocations.contains(fabLocation)) const Spacer(),
            IconButton(
              icon: const Icon(Icons.menu,color: Colors.yellow,),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today_rounded),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  var profile = _CreateJobPageState.profile;
                  return LogTestPage(
                    user: profile,
                  );
                }));
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  var profile = _CreateJobPageState.profile;
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
