import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mytestapp/UI/dashboard_page.dart';
import 'package:mytestapp/UI/logtest_page.dart';
import 'package:mytestapp/UI/setting_page.dart';
import 'package:mytestapp/model/job_model.dart';
import 'package:mytestapp/model/user_model.dart';
import 'package:mytestapp/services/limitout.dart';
import 'package:mytestapp/services/nowdate.dart';

import 'createjob_page.dart';

class JobAlertPage extends StatefulWidget {
  UserModel user;
  JobModel job;
  JobAlertPage({Key? key, required this.user, required this.job})
      : super(key: key);

  @override
  _JobAlertPageState createState() => _JobAlertPageState();
}

class _JobAlertPageState extends State<JobAlertPage> {
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
    super.initState();

    FirebaseFirestore.instance
        .collection("Users")
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.forEach((document) {
                //String a = document.id;
                //String b = document["CreaterID"];
                if (job.CreaterID == document.id) {
                  setState(() {
                    if (document["Role"] == "Addmin") {}
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
  }

  CollectionReference log = FirebaseFirestore.instance.collection("Log");
  _recived() async {
     DateTime _now = DateTime.now();
     String date =
         '${_now.day}/${_now.month}/${_now.year} ${_now.hour}:${_now.minute}';
    List<String> split = job.Time.split(" ");
    String datelimit = Limitout().TimeLimit(date, split[0]);
    
    await FirebaseFirestore.instance.collection("Jobs").doc(job.jobID).update({
      "Status": "In Progress",
      "Recive": user.ID,
      "DateTimeLimit": datelimit,
    });
    //Reciver Log
    await log.doc().set({
      "JobID": job.jobID,
      "Owner": user.ID,
      "DateLog": date,
      "Status": "In Progress",
      "Type": "User",
      "DateAt": DateTime.now().millisecondsSinceEpoch,
    });
    //Creater Log
    await log.doc().set({
      "JobID": job.jobID,
      "Owner": job.CreaterID,
      "DateLog": date,
      "Status": "In Progress",
      "Type": "Create",
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
                    "Owner": document["MemberID"],
                    "DateLog": date,
                    "Status": "In Progress",
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
                      "Status": "In Progress",
                      "Type": "Addmin",
                      "DateAt": DateTime.now().millisecondsSinceEpoch,
                    });
                  }
                });
              })
            });
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

  String note = 'Note';
  String name = '';

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
            height: size.height * 0.2,
            width: size.width * 0.9,
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
                        "Form",
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
                  Text(
                    job.DateTime,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.grey,
              width: size.width * 0.8,
              height: size.height * 0.3,
              child: _setImage(),
            ),
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
                      width: size.width * 0.025,
                    ),
                    InkWell(
                      onTap: () async {
                        await _recived();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          //var profile = _DashboardState.profile;
                          return DashboardPage(
                            user: user,
                          );
                        }));
                      },
                      child: Container(
                        height: size.height * 0.08,
                        width: size.width * 0.95,
                        decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: const Center(
                            child: Text(
                          "Recive",
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.025,
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
                  var profile = _JobAlertPageState.profile;
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
                  var profile = _JobAlertPageState.profile;
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
                  var profile = _JobAlertPageState.profile;
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
                  var profile = _JobAlertPageState.profile;
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
