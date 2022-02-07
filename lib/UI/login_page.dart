import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mytestapp/UI/dashboard_page.dart';
import 'package:mytestapp/UI/log_page.dart';
import 'package:mytestapp/UI/setting_page.dart';
import 'package:mytestapp/UI/signup_page.dart';
import 'package:mytestapp/model/user_model.dart';
import 'package:mytestapp/services/log_in.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";

  var data;

  UserModel user = UserModel(
      ID: '',
      Email: '',
      Password: '',
      Name: '',
      LineID: '',
      Image: '',
      Role: '');

  _getID(String email, String pass) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .where("Email", isEqualTo: email)
        .where("Password", isEqualTo: pass)
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.forEach((document) {
                if (document.id != null) {
                  user.ID = document.id;
                }
              })
            });
    //showUser();
    if (user.Role == 'Delete') {
      print("User has Delete");
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return DashboardPage(
          user: user,
        );
      }));
    }
  }

  showUser() {
    print(user.ID);
    print(user.Name);
    print(user.LineID);
    print(user.Email);
    print(user.Password);
    print(user.Image);
    print(user.Role);
  }

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
              resizeToAvoidBottomInset: false,
              //backgroundColor: const Color(0xFF5E9DA2),
              body: Column(
                children: [
                  Container(
                    height: size.height * 0.35,
                    color: const Color(0xFF5E9DA2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: size.height * 0.2,
                          width: size.width * 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                                "lib/assets/images/Idea Trade Plus(W).png"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: size.height * 0.65,
                    color: const Color(0xFF025564),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                              "Welcome",
                              style:
                                  TextStyle(fontSize: 40, color: Colors.white),
                            ),
                          ),
                          const Text(
                            "Login to continue",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 5.5, bottom: 5.5),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "กรุณาใส่อีเมล";
                                  } else {
                                    bool emailValid = RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value);
                                    if (emailValid == false) {
                                      return "รูปแบบอีเมลไม่ถูกต้อง";
                                    }
                                  }
                                },
                                style: const TextStyle(color: Colors.white),
                                onSaved: (value) =>
                                    setState(() => email = value!),
                                decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.mail,
                                      color: Colors.yellow,
                                    ),
                                    labelText: "Email",
                                    //hintText: "Input email",
                                    labelStyle:
                                        const TextStyle(color: Colors.white),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                              )),
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 5.5, bottom: 5.5),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "กรุณาใส่รหัสผ่าน";
                                  }
                                },
                                obscureText: true,
                                style: const TextStyle(color: Colors.white),
                                onSaved: (value) =>
                                    setState(() => password = value!),
                                decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                      color: Colors.yellow,
                                    ),
                                    labelText: "Password",
                                    //hintText: "Input password",
                                    labelStyle:
                                        const TextStyle(color: Colors.white),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                              )),
                          SizedBox(
                            height: size.height * 0.05,
                          ),
                          SizedBox(
                            width: size.width * 0.95,
                            height: size.height * 0.05,
                            child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState!.save();

                                    log_in()
                                        .getUser(email, password)
                                        .then((QuerySnapshot docs) async {
                                      if (docs.docs.isNotEmpty) {
                                        print("Log in!!!");
                                        data = docs.docs[0];

                                        user.Name = data["Name"].toString();
                                        user.Email = data["Email".toString()];
                                        user.Password =
                                            data["Password"].toString();
                                        user.LineID = data["LineID"].toString();
                                        user.Image = data["Image"].toString();
                                        user.Role = data["Role"].toString();

                                        _getID(user.Email, user.Password);

                                        formKey.currentState!.reset();
                                      } else {
                                        print("Login Error");
                                      }
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white, // background
                                  onPrimary:
                                      const Color(0xFF025564), // foreground
                                ),
                                child: const Text("Login")),
                          ),
                          SizedBox(
                            height: size.height * 0.025,
                          ),
                          const Text(
                            "Or",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(
                            height: size.height * 0.025,
                          ),
                          SizedBox(
                            width: size.width * 0.95,
                            height: size.height * 0.05,
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return SignUPPage();
                                  }));
                                },
                                style: ElevatedButton.styleFrom(
                                  side: const BorderSide(
                                    width: 1,
                                    color: Colors.white,
                                  ),
                                  primary:
                                      const Color(0xFF025564), // background
                                  onPrimary: Colors.white, // foreground
                                ),
                                child: const Text("Sign Up")),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        });
  }
}
