import 'package:flutter/material.dart';
import 'package:mytestapp/UI/createjob_page.dart';
import 'package:mytestapp/UI/jobedit.dart';
import 'package:mytestapp/UI/logtest_page.dart';
import 'package:mytestapp/UI/setting_page.dart';
import 'package:mytestapp/model/job_model.dart';
import 'package:mytestapp/model/user_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mytestapp/services/nowdate.dart';

import 'dashboard_page.dart';

class JobHelpPage extends StatefulWidget {
  UserModel user;
  JobModel job;
  JobHelpPage({Key? key, required this.user, required this.job})
      : super(key: key);

  @override
  _JobHelpPageState createState() => _JobHelpPageState();
}

class _JobHelpPageState extends State<JobHelpPage> {
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

  @override
  void initState() {
    user = widget.user;
    profile = user;
    job = widget.job;

    FirebaseFirestore.instance
        .collection("Users")
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.forEach((document) {
                //String a = document.id;
                //String b = document["CreaterID"];
                if (job.CreaterID == document.id) {
                  setState(() {
                    name = document["Name"];
                  });
                }
              })
            });
    setState(() {
      if (job.Note != '') {
        note = job.Note;
      }
    });

    super.initState();
  }

  String name = '';
  String note = 'Note';
  String reason = '';
  final formKey = GlobalKey<FormState>();

  CollectionReference log = FirebaseFirestore.instance.collection("Log");

  _done() async {
    await FirebaseFirestore.instance.collection("Jobs").doc(job.jobID).update({
      "Status": "Done",
      "Reason": reason,
    });

    DateTime _now = DateTime.now();
    String date =
        '${_now.day}/${_now.month}/${_now.year} ${_now.hour}:${_now.minute}';
    //Action Log
    await log.doc().set({
      "JobID": job.jobID,
      "Owner": user.ID,
      "DateLog": date,
      "Status": "Done",
      "Type": "User",
      "DateAt": DateTime.now().millisecondsSinceEpoch,
    });
    //Creater Log
    await log.doc().set({
      "JobID": job.jobID,
      "Owner": job.CreaterID,
      "DateLog": date,
      "Status": "Done",
      "Type": "User",
      "DateAt": DateTime.now().millisecondsSinceEpoch,
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
                    "Status": "Done",
                    "Type": "Leader",
                    "DateAt": DateTime.now().millisecondsSinceEpoch,
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
                      "Status": "Dones",
                      "Type": "User",
                      "DateAt": DateTime.now().millisecondsSinceEpoch,
                    });
                  }
                });
              })
            });
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DashboardPage(
        user: user,
      );
    }));
  }

  _cancel() async {
    await FirebaseFirestore.instance.collection("Jobs").doc(job.jobID).update({
      "Status": "Cancel",
      "Reason": reason,
    });
    DateTime _now = DateTime.now();
    String date =
        '${_now.day}/${_now.month}/${_now.year} ${_now.hour}:${_now.minute}';
    //Action Log
    await log.doc().set({
      "JobID": job.jobID,
      "Owner": user.ID,
      "DateLog": date,
      "Status": "Cancel",
      "Type": "User",
      "DateAt": DateTime.now().millisecondsSinceEpoch,
    });
    //Creater Log
    await log.doc().set({
      "JobID": job.jobID,
      "Owner": job.CreaterID,
      "DateLog": date,
      "Status": "Cancel",
      "Type": "User",
      "DateAt": DateTime.now().millisecondsSinceEpoch,
    });
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
                    "Status": "Done",
                    "Type": "Leader",
                    "DateAt": DateTime.now().millisecondsSinceEpoch,
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
                      "Status": "Cancel",
                      "Type": "User",
                      "DateAt": DateTime.now().millisecondsSinceEpoch,
                    });
                  }
                });
              })
            });
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DashboardPage(
        user: user,
      );
    }));
  }

  Container _setImage() {
    if (job.JobImage == '') {
      return Container(
        color: Colors.grey,
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.3,
      );
    }
    return Container(
        color: Colors.grey,
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.3,
        child: Image(image: NetworkImage(job.JobImage), fit: BoxFit.cover));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
          CircleAvatar(radius: 20, backgroundImage: NetworkImage(user.Image)),
          const SizedBox(
            width: 15,
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            //color: Colors.tealAccent,
            height: size.height * 0.2,
            width: size.width * 0.9,

            // decoration: const BoxDecoration(
            //     //color: Colors.blue,
            //     borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const Text(
                        "Recived",
                        style: TextStyle(fontSize: 16, color: Colors.yellow),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Text(
                        name,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Team",
                        style: TextStyle(fontSize: 16, color: Colors.yellow),
                      ),
                      const SizedBox(
                        width: 65,
                      ),
                      Text(
                        job.JobTeam,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Subject",
                        style: TextStyle(fontSize: 16, color: Colors.yellow),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Text(
                        job.Subject,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Time",
                        style: TextStyle(fontSize: 16, color: Colors.yellow),
                      ),
                      const SizedBox(
                        width: 68,
                      ),
                      Text(
                        job.Time,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Reason",
                        style: TextStyle(fontSize: 16, color: Colors.yellow),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Text(
                        job.Reason,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      )
                    ],
                  ),
                  Text(
                    job.DateTime,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _setImage(),
          ),
          Form(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    maxLines: 1,
                    enabled: false,
                    //validator: (value) {},
                    //style: const TextStyle(color: Colors.grey),
                    onSaved: (value) => setState(() => note = value!),
                    decoration: InputDecoration(
                        labelText: note,
                        fillColor: Colors.grey,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: size.width * 0.1,
                    ),
                    InkWell(
                      onTap: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('โปรดระบุเหตุผล'),
                          //content: const Text('AlertDialog description'),
                          actions: <Widget>[
                            Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "ระบุเหตุผล";
                                      }
                                    },
                                    onSaved: (value) =>
                                        setState(() => reason = value!),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        formKey.currentState!.save();
                                        await _cancel();
                                      }
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      child: Container(
                        height: size.height * 0.08,
                        width: size.width * 0.2,
                        decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: const Center(
                            child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.1,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return EditJobPage(
                            user: user,
                            job: job,
                          );
                        }));
                      },
                      child: Container(
                        height: size.height * 0.08,
                        width: size.width * 0.2,
                        decoration: const BoxDecoration(
                            color: Colors.orange,
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
                      width: size.width * 0.1,
                    ),
                    InkWell(
                      onTap: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('โปรดระบุเหตุผล'),
                          //content: const Text('AlertDialog description'),
                          actions: <Widget>[
                            Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "ระบุเหตุผล";
                                      }
                                    },
                                    onSaved: (value) =>
                                        setState(() => reason = value!),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        formKey.currentState!.save();
                                        await _done();
                                      }
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      child: Container(
                        height: size.height * 0.08,
                        width: size.width * 0.2,
                        decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: const Center(
                            child: Text(
                          "Done",
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.1,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _DemoBottomAppBar(),
    );
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
      color: Colors.teal[900],
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
                  var profile = _JobHelpPageState.profile;
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
                  var profile = _JobHelpPageState.profile;
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
                  var profile = _JobHelpPageState.profile;
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
                  var profile = _JobHelpPageState.profile;
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
