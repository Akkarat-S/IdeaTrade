import 'package:flutter/material.dart';
import 'package:mytestapp/UI/createjob_page.dart';
import 'package:mytestapp/UI/dashboard_page.dart';
import 'package:mytestapp/UI/logtest_page.dart';
import 'package:mytestapp/UI/setting_page.dart';
import 'package:mytestapp/model/job_model.dart';
import 'package:mytestapp/model/user_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mytestapp/services/nowdate.dart';

class JobDetailPage extends StatefulWidget {
  UserModel user;
  JobModel job;
  JobDetailPage({Key? key, required this.user, required this.job})
      : super(key: key);

  @override
  _JobDetailPageState createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
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
  String name = '';

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
      _setName();
    });
    super.initState();
  }

  String note = 'Note';
  String Rename = 'Name';

  Container _Showstatus() {
    if (job.Status == 'Waiting') {
      return Container(
        color: Colors.grey,
        height: MediaQuery.of(context).size.height * 0.07,
        width: MediaQuery.of(context).size.width * 0.95,
        child: Column(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Text(
            job.Status,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, color: Colors.grey),
          ),
        ]),
      );
    } else if (job.Status == 'In Progress') {
      return Container(
        color: Colors.blue,
        height: MediaQuery.of(context).size.height * 0.07,
        width: MediaQuery.of(context).size.width * 0.95,
        child: Column(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Text(
            job.Status,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, color: Colors.grey),
          ),
        ]),
      );
    } else if (job.Status == 'Done') {
      return Container(
        color: Colors.green,
        height: MediaQuery.of(context).size.height * 0.07,
        width: MediaQuery.of(context).size.width * 0.95,
        child: Column(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Text(
            job.Status,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, color: Colors.grey),
          ),
        ]),
      );
    } else if (job.Status == 'Help') {
      return Container(
        color: Colors.red,
        height: MediaQuery.of(context).size.height * 0.07,
        width: MediaQuery.of(context).size.width * 0.95,
        child: Column(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Text(
            job.Status,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, color: Colors.grey),
          ),
        ]),
      );
    } else if (job.Status == 'Time Over') {
      return Container(
        color: Colors.yellow,
        height: MediaQuery.of(context).size.height * 0.07,
        width: MediaQuery.of(context).size.width * 0.95,
        child: Column(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Text(
            job.Status,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, color: Colors.grey),
          ),
        ]),
      );
    }
    return Container(
      color: Colors.grey,
      height: MediaQuery.of(context).size.height * 0.07,
      width: MediaQuery.of(context).size.width * 0.95,
      child: Column(children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        Text(
          job.Status,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22, color: Colors.grey),
        ),
      ]),
    );
  }

  // TextFormField _setColor() {
  //   if (job.Status == 'In Progress') {
  //     return TextFormField(
  //       textAlign: TextAlign.center,
  //       maxLines: 1,
  //       enabled: false,
  //       onSaved: (value) => setState(() => note = value!),
  //       decoration: InputDecoration(
  //           labelText: job.Status,
  //           fillColor: Colors.blue,
  //           filled: true,
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(5.0),
  //           )),
  //     );
  //   } else if (job.Status == 'Time Over') {
  //     return TextFormField(
  //       textAlign: TextAlign.center,
  //       maxLines: 1,
  //       enabled: false,
  //       //validator: (value) {},
  //       //style: const TextStyle(color: Colors.grey),
  //       onSaved: (value) => setState(() => note = value!),
  //       decoration: InputDecoration(
  //           labelText: job.Status,
  //           fillColor: Colors.yellow,
  //           filled: true,
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(5.0),
  //           )),
  //     );
  //   } else if (job.Status == 'Done') {
  //     return TextFormField(
  //       textAlign: TextAlign.center,
  //       maxLines: 1,
  //       enabled: false,
  //       //validator: (value) {},
  //       //style: const TextStyle(color: Colors.grey),
  //       onSaved: (value) => setState(() => note = value!),
  //       decoration: InputDecoration(
  //           labelText: job.Status,
  //           fillColor: Colors.green,
  //           filled: true,
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(5.0),
  //           )),
  //     );
  //   } else if (job.Status == "Waitting") {
  //     return TextFormField(
  //       textAlign: TextAlign.center,
  //       maxLines: 1,
  //       enabled: false,
  //       //validator: (value) {},
  //       //style: const TextStyle(color: Colors.grey),
  //       onSaved: (value) => setState(() => note = value!),
  //       decoration: InputDecoration(
  //           labelText: job.Status,
  //           fillColor: Colors.grey,
  //           filled: true,
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(5.0),
  //           )),
  //     );
  //   }
  //   return TextFormField(
  //     textAlign: TextAlign.center,
  //     maxLines: 1,
  //     enabled: false,
  //     //validator: (value) {},
  //     //style: const TextStyle(color: Colors.grey),
  //     onSaved: (value) => setState(() => note = value!),
  //     decoration: InputDecoration(
  //         labelText: job.Status,
  //         fillColor: Colors.grey,
  //         filled: true,
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(5.0),
  //         )),
  //   );
  // }

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

_setName(){
    //String txt = '';
     FirebaseFirestore.instance
        .collection("Users")
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.forEach((document) {
                if(job.Recive == document.id){
                  Rename = document["Name"];
                }
              })
            });
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
                        Rename,// job.Recive,
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _Showstatus(), //_setColor(),
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
                  var profile = _JobDetailPageState.profile;
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
                  var profile = _JobDetailPageState.profile;
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
                  var profile = _JobDetailPageState.profile;
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
                  var profile = _JobDetailPageState.profile;
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
