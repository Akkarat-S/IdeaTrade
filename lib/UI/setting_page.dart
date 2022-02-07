import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mytestapp/UI/createjob_page.dart';
import 'package:mytestapp/UI/dashboard_page.dart';
import 'package:mytestapp/UI/editpass_page.dart';
import 'package:mytestapp/UI/editprofile_page.dart';
import 'package:mytestapp/UI/login_page.dart';
import 'package:mytestapp/UI/logtest_page.dart';
import 'package:mytestapp/model/user_model.dart';
import 'package:mytestapp/services/nowdate.dart';

class SettingPage extends StatefulWidget {
  UserModel user;
  SettingPage({Key? key, required this.user}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  void initState() {
    user = widget.user;

    setState(() {
      name = user.Name;
      line = user.LineID;
      mail = user.Email;
      url = user.Image;
      profile = user;
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

  String name = 'name', line = 'line', mail = 'mail';
  String url =
      'https://firebasestorage.googleapis.com/v0/b/testdataapp-d6da7.appspot.com/o/images?alt=media&token=ac8bd244-56c1-48dc-929e-2237c0bac0b4';

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
              body: Container(
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
                              "Setting",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: size.height * 0.3,
                      width: size.width * 1,
                      //color: const Color(0xFF5E9DA2),
                      child: CircleAvatar(
                          radius: (size.height * 0.12),
                          backgroundImage: NetworkImage(url)),
                    ),
                    Container(
                      //color: Colors.white,
                      height: size.height * 0.33,
                      child: Column(
                        children: [
                          const Divider(color: Colors.white),
                          Container(
                            height: size.height * 0.038,
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  "ชื่อ",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  name,
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          const Divider(color: Colors.white),
                          Container(
                            height: size.height * 0.038,
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  "LineID",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  line,
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          const Divider(color: Colors.white),
                          Container(
                            height: size.height * 0.038,
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  "Email",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  mail,
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          const Divider(color: Colors.white),
                          InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return EditProfilePage(
                                  user: user,
                                );
                              }));
                            },
                            child: Container(
                              height: size.height * 0.038,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    "  Edit Profile",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                  Icon(
                                    Icons.navigate_next,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                          const Divider(color: Colors.white),
                          InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return EditPasswordPage(
                                  user: user,
                                );
                              }));
                            },
                            child: Container(
                              height: size.height * 0.038,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    "  Edit Password",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                  Icon(
                                    Icons.navigate_next,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                          const Divider(color: Colors.white),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: size.width * 1,
                        height: size.height * 0.06,
                        child: ElevatedButton(
                            onPressed: () => showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('ต้องการลบบัญชี'),
                                    //content: const Text('AlertDialog description'),
                                    actions: <Widget>[
                                      Form(
                                        child: Row(
                                          children: [
                                            TextButton(
                                              onPressed: () async {
                                                await FirebaseFirestore.instance
                                                    .collection("Users")
                                                    .doc(user.ID)
                                                    .update({
                                                      "Email": '',
                                                      "LineID": '',
                                                  "Role": 'Delete',
                                                });
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return LoginPage();
                                                }));
                                              },
                                              child: const Text('OK'),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  context, 'Cancel'),
                                              child: const Text('Cancel'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xFFf30702), // background
                              onPrimary: const Color(0xFF025564), // foreground
                            ),
                            child: const Text(
                              "Delete User",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            )),
                      ),
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
                  var profile = _SettingPageState.profile;
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
                  var profile = _SettingPageState.profile;
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
                  var profile = _SettingPageState.profile;
                  return LogTestPage(
                    user: profile,
                  );
                }));
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings,color: Colors.yellow),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
