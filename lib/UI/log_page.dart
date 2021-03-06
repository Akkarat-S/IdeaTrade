import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mytestapp/UI/createjob_page.dart';
import 'package:mytestapp/UI/dashboard_page.dart';
import 'package:mytestapp/UI/jobalert_page.dart';
import 'package:mytestapp/UI/jobdetail_page.dart';
import 'package:mytestapp/UI/jobhelp_page.dart';
import 'package:mytestapp/UI/jobrecive_page.dart';
import 'package:mytestapp/UI/setting_page.dart';
import 'package:mytestapp/model/job_model.dart';
import 'package:mytestapp/model/log_model.dart';
import 'package:mytestapp/model/user_model.dart';
import 'package:mytestapp/services/nowdate.dart';

class LogPage extends StatefulWidget {
  UserModel user;
  LogPage({Key? key, required this.user}) : super(key: key);
  //LogTestPage({Key? key}) : super(key: key);

  @override
  _LogPageState createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

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
    setState(() {
      user = widget.user;
      profile = user;

      _listImageCreater();
      _setLog();
    });
    // TODO: implement initState
    super.initState();
  }

  List<LogModel> logshow = [];
  List<LogModel> alllog = [];
  List<LogModel> recivelog = [];
  Map<String, bool> checkRecive = {'': false};
  List<LogModel> createlog = [];
  Map<String, bool> checkCreate = {'': false};
  List<LogModel> adminlog = [];
  Map<String, bool> checkAddmin = {'': false};
  Map<String, String> mapjobcreater = {};
  Map<String, String> mapjobsubject = {};
  Map<String, String> mapjobnote = {};
  Map<String, String> mapjobteam = {};
  Map<String, String> mapjobtime = {};

  _setLog() async {
    List<LogModel> loglist = [];
    await FirebaseFirestore.instance
        .collection("Log")
        //.orderBy('DateLog', descending: true)
        .where("Type", isEqualTo: 'User')
        .where("Owner", isEqualTo: user.ID)
        .orderBy("DateLog", descending: true)
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.forEach((document) {
                LogModel l = LogModel(
                    DateLog: '',
                    JobID: '',
                    Owner: '',
                    Type: '',
                    Status: '',
                    logID: '',
                    DateAt: DateTime.now());
                //print(document["JobID"]);
                l.logID = document.id;
                l.DateLog = document["DateLog"];
                l.JobID = document["JobID"];
                l.Owner = document["Owner"];
                l.Type = document["Type"];
                l.Status = document["Status"];
                loglist.add(l);
                Recivelogid.add(document.id);
                checkRecive[document.id] = false;
                //alllog.add(l);
              })
            });
    setState(() {
      recivelog = loglist;
    });
    List<LogModel> loglist1 = [];
    await FirebaseFirestore.instance
        .collection("Log")
        //.orderBy('DateLog', descending: true)
        .where("Type", isEqualTo: 'Create')
        .where("Owner", isEqualTo: user.ID)
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.forEach((document) {
                LogModel l = LogModel(
                    DateLog: '',
                    JobID: '',
                    Owner: '',
                    Type: '',
                    Status: '',
                    logID: '',
                    DateAt: DateTime.now());
                //print(document["JobID"]);
                l.logID = document.id;
                l.DateLog = document["DateLog"];
                l.JobID = document["JobID"];
                l.Owner = document["Owner"];
                l.Type = document["Type"];
                l.Status = document["Status"];
                loglist1.add(l);
                Createlogid.add(document.id);
                checkCreate[document.id] = false;
                //alllog.add(l);
              })
            });
    setState(() {
      createlog = loglist1;
    });
    List<LogModel> loglist2 = [];
    await FirebaseFirestore.instance
        .collection("Log")
        //.orderBy('DateLog', descending: true)
        .where("Type", isEqualTo: 'Leader')
        .where("Owner", isEqualTo: user.ID)
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.forEach((document) {
                LogModel l = LogModel(
                    DateLog: '',
                    JobID: '',
                    Owner: '',
                    Type: '',
                    Status: '',
                    logID: '',
                    DateAt: DateTime.now());
                //print(document["JobID"]);
                l.logID = document.id;
                l.DateLog = document["DateLog"];
                l.JobID = document["JobID"];
                l.Owner = document["Owner"];
                l.Type = document["Type"];
                l.Status = document["Status"];
                loglist2.add(l);
                Addminlogid.add(document.id);
                checkAddmin[document.id] = false;
                //alllog.add(l);
              })
            });
    await FirebaseFirestore.instance
        .collection("Log")
        //.orderBy('DateLog', descending: true)
        .where("Type", isEqualTo: 'Addmin')
        .where("Owner", isEqualTo: user.ID)
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.forEach((document) {
                LogModel l = LogModel(
                    DateLog: '',
                    JobID: '',
                    Owner: '',
                    Type: '',
                    Status: '',
                    logID: '',
                    DateAt: DateTime.now());
                //print(document["JobID"]);
                l.logID = document.id;
                l.DateLog = document["DateLog"];
                l.JobID = document["JobID"];
                l.Owner = document["Owner"];
                l.Type = document["Type"];
                l.Status = document["Status"];
                loglist2.add(l);
                Addminlogid.add(document.id);
                checkAddmin[document.id] = false;
                //alllog.add(l);
              })
            });
    setState(() {
      adminlog = loglist2;
    });
  }

  List<String> Recivelogid = [];
  List<String> Createlogid = [];
  List<String> Addminlogid = [];

  Map<String, String> IDuser = {};
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
                mapjobcreater[document.id] = document['CreaterID'];
                mapjobsubject[document.id] = document['Subject'];
                mapjobnote[document.id] = document['Note'];
                mapjobteam[document.id] = document['JobTeam'];
                mapjobtime[document.id] = document['DateTime'];
                IDuser[a] = b;
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
    String? userId = IDuser[jobID];
    String? userImage = userimage[userId];
    return NetworkImage(userImage!);
  }

  Color _colorstatus(String set) {
    if (set == "Help") {
      return Colors.red;
    } else if (set == "Done") {
      return Colors.green;
    } else if (set == "In Progress") {
      return Colors.blue;
    } else if (set == "Time Over") {
      return Colors.yellow;
    }
    return Colors.white;
  }

  Container _toptab() {
    if (stage == "Start") {
      return Container(
        child: Row(
          children: [
            InkWell(
              onTap: () {
                print('set Your Log!!!');
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: const BoxDecoration(
                  color: Color(0xFF025564),
                  // borderRadius:
                  //     BorderRadius.all(Radius.circular(10))
                ),
                child: const Center(
                    child: Text(
                  "Your Log",
                  style: TextStyle(color: Colors.white),
                )),
              ),
            ),
            InkWell(
              onTap: () {
                print('set Total Log!!!');
                setState(() {
                  stage = "Total";
                });
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  // borderRadius:
                  //     BorderRadius.all(Radius.circular(10))
                ),
                child: const Center(
                    child: Text(
                  "Total Log",
                  style: TextStyle(color: Colors.white),
                )),
              ),
            ),
          ],
        ),
      );
    } else if (stage == "Total") {
      return Container(
        child: Row(
          children: [
            InkWell(
              onTap: () {
                print('set Your Log!!!');
                setState(() {
                  stage = "Start";
                });
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  // borderRadius:
                  //     BorderRadius.all(Radius.circular(10))
                ),
                child: const Center(
                    child: Text(
                  "Your Log",
                  style: TextStyle(color: Colors.white),
                )),
              ),
            ),
            InkWell(
              onTap: () {
                print('set Total Log!!!');
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: const BoxDecoration(
                  color: Color(0xFF025564),
                  // borderRadius:
                  //     BorderRadius.all(Radius.circular(10))
                ),
                child: const Center(
                    child: Text(
                  "Total Log",
                  style: TextStyle(color: Colors.white),
                )),
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }

  String stage = "Start";
  String logtype = "Recive";
  bool selectjob = false;

  Container _log() {
    if (stage == "Start") {
      if (logtype == "Recive") {
        if (selectjob == true) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    bottomRight: Radius.circular(25))),
            //color: Colors.grey,
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.6,
            child: ListView.builder(
              itemCount: recivelog.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      //decoration:const BoxDecoration(color: Colors.green,borderRadius: BorderRadius.only(topRight: Radius.circular(25), bottomRight: Radius.circular(25))),
                      //color: _colorstatus(alllog[index].Status),
                      color: Colors.white,
                      width: double.infinity,
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: checkRecive[recivelog[index].logID],
                                    //groupValue: mapcheck[i],
                                    onChanged: (value) {
                                      setState(() {
                                        var id = recivelog[index].logID;
                                        print('$id:${checkRecive['$id']}');
                                        if (checkRecive['$id'] == false) {
                                          //print(id);
                                          checkRecive['$id'] = true;
                                        } else if (checkRecive['$id'] == true) {
                                          checkRecive['$id'] = false;
                                        }
                                      });
                                    },
                                  ),
                                  CircleAvatar(
                                      radius: 15,
                                      backgroundImage:
                                          _image(recivelog[index].JobID)),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "${mapjobsubject["${recivelog[index].JobID}"]}",
                                    style: const TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                              Text(
                                "${mapjobnote["${recivelog[index].JobID}"]}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                "Team ${mapjobteam["${recivelog[index].JobID}"]}\n${mapjobtime["${recivelog[index].JobID}"]}",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(
                                Icons.circle,
                                color: _colorstatus(recivelog[index].Status),
                                //Colors.pinkAccent,
                              ),
                              Text(
                                recivelog[index].DateLog,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  bottomRight: Radius.circular(25))),
          //color: Colors.grey,
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.6,
          child: ListView.builder(
            itemCount: recivelog.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    //decoration:const BoxDecoration(color: Colors.green,borderRadius: BorderRadius.only(topRight: Radius.circular(25), bottomRight: Radius.circular(25))),
                    //color: _colorstatus(alllog[index].Status),
                    color: Colors.white,
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                    radius: 15,
                                    backgroundImage:
                                        _image(recivelog[index].JobID)),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "${mapjobsubject["${recivelog[index].JobID}"]}",
                                  style: const TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                            Text(
                              "${mapjobnote["${recivelog[index].JobID}"]}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              "Team ${mapjobteam["${recivelog[index].JobID}"]}\n${mapjobtime["${recivelog[index].JobID}"]}",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(
                              Icons.circle,
                              color: _colorstatus(recivelog[index].Status),
                              //Colors.pinkAccent,
                            ),
                            Text(
                              recivelog[index].DateLog,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      } else if (logtype == "Create") {
        if (selectjob == true) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    bottomRight: Radius.circular(25))),
            //color: Colors.grey,
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.6,
            child: ListView.builder(
              itemCount: createlog.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      //decoration:const BoxDecoration(color: Colors.green,borderRadius: BorderRadius.only(topRight: Radius.circular(25), bottomRight: Radius.circular(25))),
                      //color: _colorstatus(alllog[index].Status),
                      color: Colors.white,
                      width: double.infinity,
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: checkCreate[createlog[index].logID],
                                    //groupValue: mapcheck[i],
                                    onChanged: (value) {
                                      setState(() {
                                        var id = createlog[index].logID;
                                        print('$id:${checkCreate['$id']}');
                                        if (checkCreate['$id'] == false) {
                                          //print(id);
                                          checkCreate['$id'] = true;
                                        } else if (checkCreate['$id'] == true) {
                                          checkCreate['$id'] = false;
                                        }
                                      });
                                    },
                                  ),
                                  CircleAvatar(
                                      radius: 15,
                                      backgroundImage:
                                          _image(createlog[index].JobID)),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "${mapjobsubject["${createlog[index].JobID}"]}",
                                    style: const TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                              Text(
                                "${mapjobnote["${createlog[index].JobID}"]}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                "Team ${mapjobteam["${createlog[index].JobID}"]}\n${mapjobtime["${createlog[index].JobID}"]}",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(
                                Icons.circle,
                                color: _colorstatus(createlog[index].Status),
                                //Colors.pinkAccent,
                              ),
                              Text(
                                createlog[index].DateLog,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  bottomRight: Radius.circular(25))),
          //color: Colors.grey,
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.6,
          child: ListView.builder(
            itemCount: createlog.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    //decoration:const BoxDecoration(color: Colors.green,borderRadius: BorderRadius.only(topRight: Radius.circular(25), bottomRight: Radius.circular(25))),
                    //color: _colorstatus(alllog[index].Status),
                    color: Colors.white,
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                    radius: 15,
                                    backgroundImage:
                                        _image(createlog[index].JobID)),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "${mapjobsubject["${createlog[index].JobID}"]}",
                                  style: const TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                            Text(
                              "${mapjobnote["${createlog[index].JobID}"]}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              "Team ${mapjobteam["${createlog[index].JobID}"]}\n${mapjobtime["${createlog[index].JobID}"]}",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(
                              Icons.circle,
                              color: _colorstatus(createlog[index].Status),
                              //Colors.pinkAccent,
                            ),
                            Text(
                              createlog[index].DateLog,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(25),
                bottomRight: Radius.circular(25))),
        //color: Colors.grey,
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.6,
      );
    } else if (stage == "Total") {
      if (selectjob == true) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  bottomRight: Radius.circular(25))),
          //color: Colors.grey,
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.6,
          child: ListView.builder(
            itemCount: adminlog.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    color: Colors.white,
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: checkAddmin[adminlog[index].logID],
                                  //groupValue: mapcheck[i],
                                  onChanged: (value) {
                                    setState(() {
                                      var id = adminlog[index].logID;
                                      print('$id:${checkAddmin['$id']}');
                                      if (checkAddmin['$id'] == false) {
                                        //print(id);
                                        checkAddmin['$id'] = true;
                                      } else if (checkAddmin['$id'] == true) {
                                        checkAddmin['$id'] = false;
                                      }
                                    });
                                  },
                                ),
                                CircleAvatar(
                                    radius: 15,
                                    backgroundImage:
                                        _image(adminlog[index].JobID)),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "${mapjobsubject["${adminlog[index].JobID}"]}",
                                  style: const TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                            Text(
                              "${mapjobnote["${adminlog[index].JobID}"]}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              "Team ${mapjobteam["${adminlog[index].JobID}"]}\n${mapjobtime["${adminlog[index].JobID}"]}",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(
                              Icons.circle,
                              color: _colorstatus(adminlog[index].Status),
                              //Colors.pinkAccent,
                            ),
                            Text(
                              adminlog[index].DateLog,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(25),
                bottomRight: Radius.circular(25))),
        //color: Colors.grey,
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.6,
        child: ListView.builder(
          itemCount: adminlog.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {},
                child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Checkbox(
                              //   value: checkAddmin[adminlog[index].logID],
                              //   //groupValue: mapcheck[i],
                              //   onChanged: (value) {
                              //     setState(() {
                              //       var id = adminlog[index].logID;
                              //       print('$id:${checkAddmin['$id']}');
                              //       if (checkAddmin['$id'] == false) {
                              //         //print(id);
                              //         checkAddmin['$id'] = true;
                              //       } else if (checkAddmin['$id'] == true) {
                              //         checkAddmin['$id'] = false;
                              //       }
                              //     });
                              //   },
                              // ),
                              CircleAvatar(
                                  radius: 15,
                                  backgroundImage:
                                      _image(adminlog[index].JobID)),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "${mapjobsubject["${adminlog[index].JobID}"]}",
                                style: const TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                          Text(
                            "${mapjobnote["${adminlog[index].JobID}"]}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Team ${mapjobteam["${adminlog[index].JobID}"]}\n${mapjobtime["${adminlog[index].JobID}"]}",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(
                            Icons.circle,
                            color: _colorstatus(adminlog[index].Status),
                            //Colors.pinkAccent,
                          ),
                          Text(
                            adminlog[index].DateLog,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(25), bottomRight: Radius.circular(25))),
      //color: Colors.grey,
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.6,
    );
  }

  Container _logmenu() {
    if (stage == "Start") {
      return Container(
        height: MediaQuery.of(context).size.height * 0.12,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                setState(() {
                  print('Select');
                  if (selectjob == false) {
                    selectjob = true;
                  } else if (selectjob == true) {
                    if (logtype == "Recive") {
                      for (var i in Recivelogid) {
                        if (checkRecive[i] == true) {
                          FirebaseFirestore.instance
                              .collection("Log")
                              .doc(i)
                              .delete();
                        }
                      } //setState(() {});
                    } else if (logtype == "Create") {
                      for (var i in Createlogid) {
                        if (checkCreate[i] == true) {
                          FirebaseFirestore.instance
                              .collection("Log")
                              .doc(i)
                              .delete();
                        }
                      } //setState(() {});
                    }
                    selectjob = false;
                  }
                });
                setState(() {
                  _setLog();
                });
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.44,
                decoration: const BoxDecoration(
                    color: Color(0xFFF08080),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: const Center(
                    child: Text(
                  "???????????????",
                  style: TextStyle(color: Colors.white),
                )),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ),
            Column(
              children: [
                InkWell(
                  onTap: () {
                    print('Recive log');
                    setState(() {
                      logtype = "Recive";
                    });
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.44,
                    decoration: const BoxDecoration(
                        color: Color(0xFF4Fed49),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: const Center(
                        child: Text(
                      "Recive Log",
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    print('Create log');
                    setState(() {
                      logtype = "Create";
                    });
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.44,
                    decoration: const BoxDecoration(
                        color: Color(0xFF5E9DA2),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: const Center(
                        child: Text(
                      "Create Log",
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    } else if (stage == "Total") {
      return Container(
        height: MediaQuery.of(context).size.height * 0.12,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              InkWell(
                onTap: () {
                  setState(() {
                    print('Select');
                    if (selectjob == false) {
                      selectjob = true;
                    } else if (selectjob == true) {
                      for (var i in Addminlogid) {
                        if (checkAddmin[i] == true) {
                          FirebaseFirestore.instance
                              .collection("Log")
                              .doc(i)
                              .delete();
                        }
                      }
                      selectjob = false;
                      _setLog();
                    }
                  });
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.44,
                  decoration: const BoxDecoration(
                      color: Color(0xFFF08080),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: const Center(
                      child: Text(
                    "???????????????",
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              ),
              // const SizedBox(
              //   height: 10,
              // ),
              // InkWell(
              //   onTap: () {
              //     print('Sort');
              //   },
              //   child: Container(
              //     height: MediaQuery.of(context).size.height * 0.05,
              //     width: MediaQuery.of(context).size.width * 0.44,
              //     decoration: const BoxDecoration(
              //         color: Color(0xFFF08080),
              //         borderRadius: BorderRadius.all(Radius.circular(10))),
              //     child: const Center(
              //         child: Text(
              //       "Sort",
              //       style: TextStyle(color: Colors.white),
              //     )),
              //   ),
              // ),
            ]),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    print('Sort');
                    setState(() {
                      //logtype = "Recive";
                    });
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.44,
                    decoration: const BoxDecoration(
                        color: Color(0xFF4Fed49),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: const Center(
                        child: Text(
                      "Sort",
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                // InkWell(
                //   onTap: () {
                //     print('Create log');
                //     setState(() {
                //       logtype = "Create";
                //     });
                //   },
                //   child: Container(
                //     height: MediaQuery.of(context).size.height * 0.05,
                //     width: MediaQuery.of(context).size.width * 0.44,
                //     decoration: const BoxDecoration(
                //         color: Color(0xFF5E9DA2),
                //         borderRadius: BorderRadius.all(Radius.circular(10))),
                //     child: const Center(
                //         child: Text(
                //       "Create Log",
                //       style: TextStyle(color: Colors.white),
                //     )),
                //   ),
                // ),
              ],
            )
          ],
        ),
      );
    }
    return Container();
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
              body: Column(
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _toptab(),
                  const SizedBox(
                    height: 10,
                  ),
                  _logmenu(),
                  const SizedBox(
                    height: 20,
                  ),
                  _log(),
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
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  var profile = _LogPageState.profile;
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
                  var profile = _LogPageState.profile;
                  return CreateJobPage(
                    user: profile,
                  );
                }));
              },
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today_rounded,
                  color: Colors.yellow),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  var profile = _LogPageState.profile;
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
