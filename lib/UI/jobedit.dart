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
import 'package:mytestapp/model/job_model.dart';
import 'package:mytestapp/model/user_model.dart';
import 'package:mytestapp/services/nowdate.dart';

class EditJobPage extends StatefulWidget {
  UserModel user;
  JobModel job;
  EditJobPage({Key? key, required this.user, required this.job})
      : super(key: key);

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference jobDB = FirebaseFirestore.instance.collection("Jobs");

  @override
  void initState() {
    user = widget.user;
    profile = user;
    job = widget.job;
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
    setState(() {
      valueteam = job.JobTeam;
      valuetime = job.Time;
      txtconsubject.text = job.Subject;
      txtconnote.text = job.Note;
      //subject = job.Subject;
      //note = job.Note;
    });
    // TODO: implement initState
    super.initState();
  }

  final formKey = GlobalKey<FormState>();
  List<String> lsteam = ['New Team'];
  List<String> lstime = ['10', '15', '20', '30', '60'];
  // final txtconsubject = TextEditingController();
  // final txtconnote = TextEditingController();

  late UserModel user;
  static UserModel profile = UserModel(
      ID: '',
      Image: '',
      Email: '',
      LineID: '',
      Name: '',
      Password: '',
      Role: '');
  late JobModel job;

  Container _addImage() {
    if (job.JobImage == '') {
      return Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.8,
        child: IconButton(onPressed: () {}, icon: const Icon(Icons.add_circle)),
      );
    }
    return Container(
      //color: Colors.white,
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Image.network(job.JobImage),
    );
  }

  String valueteam = "Select Team";
  String valuetime = "Select Time";

  CollectionReference log = FirebaseFirestore.instance.collection("Log");

  late String subject, note;
  final txtconsubject = TextEditingController();
  final txtconnote = TextEditingController();

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
            //txtconsubject.text = job.Subject ;
            //txtconnote.text = job.Note;
            return Scaffold(
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
                                controller: txtconsubject,
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
                        controller: txtconnote,
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
                              print(
                                  "-----\n$valueteam\n$subject\n$valuetime\n$note");
                              await FirebaseFirestore.instance
                                  .collection("Jobs")
                                  .doc(job.jobID)
                                  .update({
                                "JobTeam": valueteam,
                                "Subject": subject,
                                "Time": valuetime,
                                "Note": note,
                                "JobImage": job.JobImage,
                                "CreaterID": user.ID,
                                "Recive": "",
                                "Status": "Waiting",
                                "DateTime": date,
                                "DateTimeLimit": '',
                                "Reason": '',
                              });
                              //Action Log
                              await log.doc().set({
                                "JobID": job.jobID,
                                "Owner": user.ID,
                                "DateLog": date,
                                "Status": "Waitng",
                                "Type": "User",
                              });
                              //Creater Log
                              await log.doc().set({
                                "JobID": job.jobID,
                                "Owner": job.CreaterID,
                                "DateLog": date,
                                "Status": "Waiting",
                                "Type": "User",
                              });
                              //Leader Log
                              await FirebaseFirestore.instance
                                  .collection("TeamMember")
                                  .where("Role", isEqualTo: "Leader")
                                  .where("TeamName", isEqualTo: job.JobTeam)
                                  .get()
                                  .then((querySnapshot) => {
                                        querySnapshot.docs.forEach((document) {
                                          setState(() {
                                            log.doc().set({
                                              "JobID": job.jobID,
                                              "Owner": document.id,
                                              "DateLog": date,
                                              "Status": "Waiting",
                                              "Type": "Leader",
                                            });
                                          });
                                        })
                                      });
                              //Addmin Log
                              await FirebaseFirestore.instance
                                  .collection("Users")
                                  .get()
                                  .then((querySnapshot) => {
                                        querySnapshot.docs.forEach((document) {
                                          setState(() {
                                            if (document["Role"] == "Addmin") {
                                              log.doc().set({
                                                "JobID": job.jobID,
                                                "Owner": document.id,
                                                "DateLog": date,
                                                "Status": "Waiting",
                                                "Type": "Addmin",
                                              });
                                            }
                                          });
                                        })
                                      });
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return DashboardPage(
                                  user: user,
                                );
                              }));
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
                              "Edit",
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
                              //pathImage = '';
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
              icon: const Icon(Icons.home,color: Colors.yellow),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  var profile = _EditJobPageState.profile;
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
                  var profile = _EditJobPageState.profile;
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
                  var profile = _EditJobPageState.profile;
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
                  var profile = _EditJobPageState.profile;
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
