import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mytestapp/UI/createjob_page.dart';
import 'package:mytestapp/model/user_model.dart';
import 'package:mytestapp/services/nowdate.dart';

import 'dashboard_page.dart';
import 'logtest_page.dart';
import 'setting_page.dart';

class TeamSelectMember extends StatefulWidget {
  UserModel user;
  String leader;
  TeamSelectMember({Key? key, required this.leader, required this.user})
      : super(key: key);

  @override
  _TeamSelectMemberState createState() => _TeamSelectMemberState();
}

class _TeamSelectMemberState extends State<TeamSelectMember> {
  @override
  void initState() {
    user = widget.user;
    profile = user;
    leader = widget.leader;

    FirebaseFirestore.instance
        .collection("Users")
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.forEach((document) {
                setState(() {
                  print("Name:${document['Name']}");
                  print("ID:${document.id}");
                  if (document["Role"] != "Delete") {
                    if (document.id == widget.leader) {
                    } else {
                      name.add(document['Name']);
                      mapID["${document['Name']}"] = document.id;
                      mapImage[document.id] = document["Image"];
                      mapcheck[document.id] = false;
                    }
                  } else {}
                });
              })
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

  CollectionReference team = FirebaseFirestore.instance.collection("Teams");
  CollectionReference member =
      FirebaseFirestore.instance.collection("TeamMember");

  String leader = '';
  String teamname = '';

  late List<UserModel> listuser;

  List<String> name = [];
  Map<String, String> mapID = {'': ''};
  Map<String, String> mapImage = {'': ''};
  Map<String, bool> mapcheck = {'': false};

  NetworkImage _image(String name) {
    String? userId = mapID[name];
    String? userImage = mapImage[userId];
    return NetworkImage(userImage!);
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF1f5c55),
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
      body: Container(
        height: size.height * 1,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CreateJobPage(
                                user: user,
                              );
                            }));
                          },
                          icon: const Icon(Icons.close)),
                      const Text("เลือกสมาชิก"),
                    ],
                  ),
                  FlatButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          print("TeamName: $teamname");
                          await team.doc().set({
                            "TeamName": teamname,
                          });
                          print("Leader: $leader");
                          await member.doc().set({
                            "MemberID": leader,
                            "Role": "Leader",
                            "TeamName": teamname,
                          });
                          for (var i in name) {
                            var check = mapcheck[mapID[i]];
                            if (check == true) {
                              print("Name->$i : ${mapID[i]}");
                              await member.doc().set({
                                "MemberID": mapID[i],
                                "Role": "Member",
                                "TeamName": teamname,
                              });
                            }
                          }
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return CreateJobPage(
                              user: user,
                            );
                          }));
                        }
                      },
                      child: const Text("ต่อไป"))
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "กรุณาใส่ชื่อทีม";
                    }
                  },
                  //obscureText: true,
                  style: const TextStyle(color: Colors.black),
                  onSaved: (value) => setState(() => teamname = value!),
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.yellow,
                      ),
                      labelText: "ชื่อทีม",
                      //hintText: "Input password",
                      labelStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: const BoxDecoration(
                    //color: Colors.grey,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25),
                        bottomRight: Radius.circular(25))),
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.6,
                child: ListView.builder(
                  itemCount: name.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                        radius: 30,
                                        backgroundImage: _image(name[index])),
                                    SizedBox(
                                      width: size.width * 0.025,
                                    ),
                                    Text(name[index]),
                                  ],
                                ),
                                Checkbox(
                                  value: mapcheck[mapID[name[index]]],
                                  //groupValue: mapcheck[i],
                                  onChanged: (value) {
                                    setState(() {
                                      var ID = mapID[name[index]];
                                      if (mapcheck[ID] == false) {
                                        mapcheck['$ID'] = true;
                                        print(mapcheck['$ID']);
                                      } else {
                                        mapcheck['$ID'] = false;
                                        print(mapcheck['$ID']);
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ));
                  },
                ),
              )
            ],
          ),
        ),
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
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  var profile = _TeamSelectMemberState.profile;
                  return DashboardPage(
                    user: profile,
                  );
                }));
              },
            ),
            if (centerLocations.contains(fabLocation)) const Spacer(),
            IconButton(
              icon: const Icon(Icons.menu,color: Colors.yellow),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  var profile = _TeamSelectMemberState.profile;
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
                  var profile = _TeamSelectMemberState.profile;
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
                  var profile = _TeamSelectMemberState.profile;
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
