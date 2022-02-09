import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mytestapp/UI/createjob_page.dart';
import 'package:mytestapp/UI/jobalert_page.dart';
import 'package:mytestapp/UI/jobdetail_page.dart';
import 'package:mytestapp/UI/jobhelp_page.dart';
import 'package:mytestapp/UI/jobrecive_page.dart';
import 'package:mytestapp/UI/logtest_page.dart';
import 'package:mytestapp/UI/setting_page.dart';
import 'package:mytestapp/model/job_model.dart';
import 'package:mytestapp/model/user_model.dart';
import 'package:mytestapp/services/limitout.dart';
import 'package:mytestapp/services/nowdate.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mytestapp/services/timescore.dart';

class DashboardPage extends StatefulWidget {
  UserModel user;
  DashboardPage({Key? key, required this.user}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final formKey = GlobalKey<FormState>();
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

    _listImageCreater();

    // TODO: implement initState
    super.initState();
  }

  Map<String, String> jobuser = {};
  Map<String, String> userimage = {};

  _listImageCreater() {
    //get JobCreaterImage
    FirebaseFirestore.instance
        .collection("Jobs")
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.forEach((document) {
                String a = document.id;
                String b = document["CreaterID"];
                jobuser[a] = b;
              })
            });
    FirebaseFirestore.instance
        .collection("Users")
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.forEach((document) {
                String a = document.id;
                String b = document["Image"];
                userimage[a] = b;
              })
            });
  }

  NetworkImage _image(String jobID) {
    String? userId = jobuser[jobID];
    String? userImage = userimage[userId];
    return NetworkImage(userImage!);
  }

  List<JobModel> listdashboard = [];

  List<String> youTeam = [];
  List<JobModel> newAlrert = [];
  _alert() async {
    List<String> _youTeam = [];
    await FirebaseFirestore.instance
        .collection("TeamMember")
        .where("MemberID", isEqualTo: user.ID)
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.forEach((document) {
                //print(document["TeamName"]);
                _youTeam.add(document["TeamName"]);
              })
            });
    youTeam = _youTeam;
    //get alrert
    List<JobModel> alrert = [];
    await FirebaseFirestore.instance
        .collection("Jobs")
        .where("Status", isEqualTo: "Waiting")
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.forEach((document) {
                JobModel a = JobModel(
                  jobID: '',
                  CreaterID: '',
                  DateTime: '',
                  JobImage: '',
                  JobTeam: '',
                  Note: '',
                  Recive: '',
                  Status: '',
                  Subject: '',
                  DateTimeLimit: '',
                  Time: '',
                  Reason: '',
                );
                for (var i in youTeam) {
                  if (i == document["JobTeam"]) {
                    print(document.id);
                    a.jobID = document.id;
                    a.CreaterID = document["CreaterID"];
                    a.DateTime = document["DateTime"];
                    a.JobImage = document["JobImage"];
                    a.JobTeam = document["JobTeam"];
                    a.Note = document["Note"];
                    a.Recive = document["Recive"];
                    a.Status = document["Status"];
                    a.Subject = document["Subject"];
                    a.DateTimeLimit = document["DateTimeLimit"];
                    a.Time = document["Time"];
                    a.Reason = document["Reason"];
                    alrert.add(a);
                  }
                }
              })
            });
    newAlrert = alrert;
    List<JobModel> N = [];
    setState(() {
      if (stage == "NewAlert") {
        print("Start State");
        stage = "Start";
        listdashboard = N;
      } else {
        print("NewAlert State");
        stage = "NewAlert";
        listdashboard = newAlrert;
        //_showjob(listdashboard);
      }
    });
  }

  List<JobModel> listRecive = [];
  _recive() async {
    List<JobModel> recive = [];
    await FirebaseFirestore.instance
        .collection("Jobs")
        .where("Recive", isEqualTo: user.ID)
        .where("Status", isEqualTo: "In Progress")
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.forEach((document) {
                JobModel r = JobModel(
                    jobID: '',
                    CreaterID: '',
                    DateTime: '',
                    JobImage: '',
                    JobTeam: '',
                    Note: '',
                    Recive: '',
                    Status: '',
                    Subject: '',
                    Time: '',
                    DateTimeLimit: '',
                    Reason: '');
                //print(document.id);
                r.jobID = document.id;
                r.CreaterID = document["CreaterID"];
                r.DateTime = document["DateTime"];
                r.DateTimeLimit = document["DateTimeLimit"];
                r.Time = document["Time"];
                r.JobImage = document["JobImage"];
                r.JobTeam = document["JobTeam"];
                r.Note = document["Note"];
                r.Recive = document["Recive"];
                r.Status = document["Status"];
                r.Subject = document["Subject"];
                r.Reason = document["Reason"];
                recive.add(r);
              })
            });
    listRecive = recive;

    setState(() {
      if (stage == "Recived") {
        List<JobModel> N = [];
        print("Start State");
        stage = "Start";
        listdashboard = N;
      } else {
        print("Recived State");
        stage = "Recived";
        //_showjob(listdashboard);
        listdashboard = listRecive;
      }
    });
  }

  List<JobModel> listCreateJob = [];
  _ctreate() async {
    List<JobModel> jobcreate = [];
    await FirebaseFirestore.instance
        .collection("Jobs")
        .where("CreaterID", isEqualTo: user.ID)
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.forEach((document) {
                JobModel j = JobModel(
                  jobID: '',
                  CreaterID: '',
                  DateTime: '',
                  JobImage: '',
                  JobTeam: '',
                  Note: '',
                  Recive: '',
                  Status: '',
                  Subject: '',
                  DateTimeLimit: '',
                  Time: '',
                  Reason: '',
                );
                //print(document.id);
                j.jobID = document.id;
                j.CreaterID = document["CreaterID"];
                j.DateTime = document["DateTime"];
                j.JobImage = document["JobImage"];
                j.JobTeam = document["JobTeam"];
                j.Note = document["Note"];
                j.Recive = document["Recive"];
                j.Status = document["Status"];
                j.Subject = document["Subject"];
                j.DateTimeLimit = document["DateTimeLimit"];
                j.Time = document["Time"];
                j.Reason = document["Reason"];
                jobcreate.add(j);
              })
            });
    listCreateJob = jobcreate;
    List<JobModel> N = [];
    setState(() {
      if (stage == "Created") {
        print("Start State");
        stage = "Start";
        listdashboard = N;
      } else {
        print("Created State");
        stage = "Created";
        listdashboard = listCreateJob;
        //_showjob(listdashboard);
      }
    });
  }

  CollectionReference log = FirebaseFirestore.instance.collection("Log");

  _actiondone(JobModel job) async {
    await FirebaseFirestore.instance.collection("Jobs").doc(job.jobID).update({
      "Status": "Done",
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
      "Type": "Create",
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
                    "Owner": document["MemberID"],
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
                      "Status": "Done",
                      "Type": "Addmin",
                      "DateAt": DateTime.now().millisecondsSinceEpoch,
                    });
                  }
                });
              })
            });
  }

  _actionrecived(JobModel job) async {
    DateTime _now = DateTime.now();
    String date =
        '${_now.day}/${_now.month}/${_now.year} ${_now.hour}:${_now.minute}';
    List<String> split = job.Time.split(" ");
    String datelimit = await Limitout().TimeLimit(date, split[0]);
    //print(datelimit);

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
    setState(() {});
  }

  _rejob(JobModel job) async {
    await FirebaseFirestore.instance.collection("Jobs").doc(job.jobID).update({
      "JobTeam": job.JobTeam,
      "Subject": job.Subject,
      "Time": job.Time,
      "Note": job.Note,
      "JobImage": job.JobImage,
      "CreaterID": user.ID,
      "Recive": "",
      "Status": "Waiting",
      "DateTime": NowDate().datetime(),
      "DateTimeLimit": '',
      "Reason": '',
    });
  }

  late String reason;
  _actionhelp(JobModel job) async {
    await FirebaseFirestore.instance.collection("Jobs").doc(job.jobID).update({
      "Status": "Help",
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
      "Status": "Help",
      "Type": "User",
      "DateAt": DateTime.now().millisecondsSinceEpoch,
    });
    //Creater Log
    await log.doc().set({
      "JobID": job.jobID,
      "Owner": job.CreaterID,
      "DateLog": date,
      "Status": "Help",
      "Type": "Create",
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
                    "Owner": document["MemberID"],
                    "DateLog": date,
                    "Status": "Help",
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
                      "Status": "Help",
                      "Type": "User",
                      "DateAt": DateTime.now().millisecondsSinceEpoch,
                    });
                  }
                });
              })
            });
    // Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   return DashboardPage(
    //     user: user,
    //   );
    // }));
  }

  _colorstatus(String set) {
    if (set == "Help") {
      return Colors.red;
    } else if (set == "Time Over") {
      return Colors.yellow;
    }
    return Colors.white;
  }

  _setTime(JobModel job) async {
    String time = TimeScore().timescore(job.DateTimeLimit);
    print(time);
    List<String> timelimit = time.split(":");
    H = await int.parse(timelimit[0]);
    M = await int.parse(timelimit[1]);
    print("$H:$M");
    if (H < 0) {
      print("Over Time");
      timecheck = false;
    } else {
      timecheck = true;
    }
    //startTimer();
  }

  _timeover(JobModel job) async {
    await FirebaseFirestore.instance.collection("Jobs").doc(job.jobID).update({
      "Status": "Time Over",
    });
    DateTime _now = DateTime.now();
    String date =
        '${_now.day}/${_now.month}/${_now.year} ${_now.hour}:${_now.minute}';
    //Action Log
    await log.doc().set({
      "JobID": job.jobID,
      "Owner": user.ID,
      "DateLog": date,
      "Status": "Time Over",
      "Type": "User",
      "DateAt": DateTime.now().millisecondsSinceEpoch,
    });
    //Creater Log
    await log.doc().set({
      "JobID": job.jobID,
      "Owner": job.CreaterID,
      "DateLog": date,
      "Status": "Time Over",
      "Type": "Create",
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
                    "Owner": document["MemberID"],
                    "DateLog": date,
                    "Status": "Time Over",
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
                      "Status": "Time Over",
                      "Type": "Addmin",
                      "DateAt": DateTime.now().millisecondsSinceEpoch,
                    });
                  }
                });
              })
            });
    // Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   //var profile = _DashboardState.profile;
    //   return DashboardPage(
    //     user: user,
    //   );
    // }));
  }

  late bool timecheck;

  int H = 0, M = 0;

  String stage = "Start";

  ActionPane _slider(JobModel job) {
    if (stage == "Created" && job.Status == "Help") {
      return ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            flex: 2,
            onPressed: (BuildContext context) {
              setState(() {
                _rejob(job);
                stage = "Start";
                _ctreate();
              });
            },
            backgroundColor: Color(0xFF7BC043),
            foregroundColor: Colors.white,
            icon: Icons.archive,
            label: 'ReJob',
          ),
        ],
      );
    } else if (stage == "NewAlert") {
      return ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            flex: 2,
            onPressed: (BuildContext context) {
              setState(() {
                _actionrecived(job);
                stage = "Start";
                _alert();
              });
            },
            backgroundColor: Color(0xFF00a651),
            foregroundColor: Colors.white,
            icon: Icons.archive,
            label: 'Recive',
          ),
        ],
      );
    } else if (stage == "Recived") {
      return ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            flex: 2,
            onPressed: (BuildContext context) {
              showDialog<String>(
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
                            onSaved: (value) => setState(() => reason = value!),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                await _setTime(job);
                                if (timecheck == true) {
                                  await _actionhelp(job);
                                  setState(() {
                                    stage = "Start";
                                    _recive();
                                    Navigator.pop(context);
                                  });
                                } else {
                                  _timeover(job);
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text(
                                          'หมดระยะเวลาของการทำงานนี้แล้ว'),
                                      //content: const Text('AlertDialog description'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              stage = "Start";
                                              _recive();
                                              Navigator.pop(context);
                                            });
                                            Navigator.pop(context, 'OK');
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                setState(() {
                                  // stage = "Start";
                                  // _recive();
                                  // Navigator.pop(context);
                                });
                              }
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            backgroundColor: Color(0xFFf30702),
            foregroundColor: Colors.white,
            icon: Icons.archive,
            label: 'Help',
          ),
          SlidableAction(
            flex: 2,
            onPressed: (BuildContext context) async {
              // setState(() {
              await _setTime(job);
              if (timecheck == true) {
                print("Done");
                _actiondone(job);
                setState(() {
                  stage = "Start";
                  _recive();
                });
              } else {
                print("Over!");
                _timeover(job);
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('หมดระยะเวลาของการทำงานนี้แล้ว'),
                    //content: const Text('AlertDialog description'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          setState(() {
                            stage = "Start";
                            _recive();
                          });
                          Navigator.pop(context, 'OK');
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
              setState(() {
                //stage = "Start";
                //_recive();
              });
            },
            backgroundColor: Color(0xFF00a651),
            foregroundColor: Colors.white,
            icon: Icons.archive,
            label: 'Done',
          ),
        ],
      );
    }
    return const ActionPane(
      motion: ScrollMotion(),
      children: [],
    );
  }

  Text _txCreate() {
    if (stage == "Created") {
      return const Text(
        "Created",
        style: TextStyle(color: Colors.yellow, fontSize: 16),
      );
    }
    return const Text(
      "Created",
      style: TextStyle(color: Colors.white, fontSize: 16),
    );
  }

  Text _txRecived() {
    if (stage == "Recived") {
      return const Text(
        "Recived",
        style: TextStyle(color: Colors.yellow, fontSize: 16),
      );
    }
    return const Text(
      "Recived",
      style: TextStyle(color: Colors.white, fontSize: 16),
    );
  }

  Text _txNewAlert() {
    if (stage == "NewAlert") {
      return const Text(
        "New Alert",
        style: TextStyle(color: Colors.yellow, fontSize: 16),
      );
    }
    return const Text(
      "New Alert",
      style: TextStyle(color: Colors.white, fontSize: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      "Good day!  ${user.Name}",
                      textAlign: TextAlign.start,
                    ),
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
              body: Column(
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    //width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            _recive();
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width * 0.44,
                            decoration: const BoxDecoration(
                                color: Color(0xFFF08080),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Center(child: _txRecived()),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                _alert();
                              },
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.145,
                                width: MediaQuery.of(context).size.width * 0.44,
                                decoration: const BoxDecoration(
                                    color: Color(0xFF4Fed49),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Center(
                                  child: _txNewAlert(),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                _ctreate();
                              },
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.145,
                                width: MediaQuery.of(context).size.width * 0.44,
                                decoration: const BoxDecoration(
                                    color: Color(0xFF5E9DA2),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Center(child: _txCreate()),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: const BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25),
                            bottomRight: Radius.circular(25))),
                    //color: Colors.grey,
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: ListView.builder(
                      itemCount: listdashboard.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Slidable(
                            //actionPane:
                            endActionPane: _slider(listdashboard[index]),
                            child: InkWell(
                              onTap: () {
                                print(stage);
                                if (stage == "Created") {
                                  if (listdashboard[index].Status == "Help") {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      //var profile = _DashboardState.profile;
                                      return JobHelpPage(
                                        user: user,
                                        job: listdashboard[index],
                                      );
                                    }));
                                  } else {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      //var profile = _DashboardState.profile;
                                      return JobDetailPage(
                                        user: user,
                                        job: listdashboard[index],
                                      );
                                    }));
                                  }
                                } else if (stage == "NewAlert") {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    //var profile = _DashboardState.profile;
                                    return JobAlertPage(
                                      user: user,
                                      job: listdashboard[index],
                                    );
                                  }));
                                } else if (stage == "Recived") {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    //var profile = _DashboardState.profile;
                                    return JobRecivedPage(
                                      user: user,
                                      job: listdashboard[index],
                                    );
                                  }));
                                } else {
                                  print(index);
                                }
                              },
                              child: Container(
                                //decoration:const BoxDecoration(color: Colors.green,borderRadius: BorderRadius.only(topRight: Radius.circular(25), bottomRight: Radius.circular(25))),
                                color:
                                    _colorstatus(listdashboard[index].Status),
                                width: double.infinity,
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.messenger,
                                              color: Colors.pinkAccent,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              listdashboard[index].Subject,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            )
                                          ],
                                        ),
                                        Text(
                                          listdashboard[index].Note,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          "Team ${listdashboard[index].JobTeam}\n${listdashboard[index].DateTime}",
                                          style: const TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        CircleAvatar(
                                            radius: 30,
                                            backgroundImage: _image(
                                                listdashboard[index].jobID)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
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

  //get user => null;

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
              icon: const Icon(
                Icons.home,
                color: Colors.yellow,
              ),
              onPressed: () {},
            ),
            if (centerLocations.contains(fabLocation)) const Spacer(),
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  var profile = _DashboardPageState.profile;
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
                  var profile = _DashboardPageState.profile;
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
                  var profile = _DashboardPageState.profile;
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
