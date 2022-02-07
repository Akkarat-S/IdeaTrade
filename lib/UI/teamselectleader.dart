import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mytestapp/UI/createjob_page.dart';
import 'package:mytestapp/UI/dashboard_page.dart';
import 'package:mytestapp/UI/logtest_page.dart';
import 'package:mytestapp/UI/setting_page.dart';
import 'package:mytestapp/UI/teamselectmember.dart';
import 'package:mytestapp/model/user_model.dart';
import 'package:mytestapp/services/nowdate.dart';

class TeamSelectLeader extends StatefulWidget {
  UserModel user;
  TeamSelectLeader({Key? key, required this.user}) : super(key: key);

  @override
  _TeamSelectLeaderState createState() => _TeamSelectLeaderState();
}

class _TeamSelectLeaderState extends State<TeamSelectLeader> {
  @override
  void initState() {
    user = widget.user;
    profile = user;

    FirebaseFirestore.instance
        .collection("Users")
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.forEach((document) {
                setState(() {
                  print("Name:${document['Name']}");
                  print("ID:${document.id}");
                  if (document["Role"] != "Delete") {
                    name.add(document['Name']);
                    mapID["${document['Name']}"] = document.id;
                    mapImage[document.id] = document["Image"];
                    mapcheck[document.id] = false;
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

  late List<UserModel> listuser;

  List<String> name = [];
  Map<String, String> mapID = {'': ''};
  Map<String, String> mapImage = {'': ''};
  Map<String, bool> mapcheck = {'': false};

  String selectradio = '';

  NetworkImage _image(String name) {
    String? userId = mapID[name];
    String? userImage = mapImage[userId];
    return NetworkImage(userImage!);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
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
                      const Text("เลือกหัวหน้าทีม"),
                    ],
                  ),
                  FlatButton(
                      onPressed: () {
                        if (selectradio == '') {
                          print("Select Leader");
                        } else {
                          print("Name-> : $selectradio");
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            //var profile = _DashboardPageState.profile;
                            return TeamSelectMember(
                              leader: selectradio,
                              user: user,
                            );
                          }));
                        }
                      },
                      child: const Text("ต่อไป"))
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TextFormField(
            //     enabled: false,
            //     //obscureText: true,
            //     style: const TextStyle(color: Colors.white),
            //     onSaved: (value) => setState(() => value = value!),
            //     decoration: InputDecoration(
            //         fillColor: Colors.white,
            //         filled: true,
            //         prefixIcon: const Icon(
            //           Icons.search,
            //           color: Colors.yellow,
            //         ),
            //         labelText: "ค้นหา",
            //         //hintText: "Input password",
            //         labelStyle: const TextStyle(color: Colors.black),
            //         border: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(5.0))),
            //   ),
            // ),
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
                                //crossAxisAlignment: CrossAxisAlignment.stretch,
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
                              Radio(
                                value: '${mapID[name[index]]}',
                                groupValue: selectradio,
                                //activeColor: Colors.blue,
                                onChanged: (val) {
                                  setState(() {
                                    String v = '${mapID[name[index]]}';
                                    print(v);
                                    selectradio = v;
                                    //setSelectedRadio(selectradio);
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
                  var profile = _TeamSelectLeaderState.profile;
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
                  var profile = _TeamSelectLeaderState.profile;
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
                  var profile = _TeamSelectLeaderState.profile;
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
                  var profile = _TeamSelectLeaderState.profile;
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
