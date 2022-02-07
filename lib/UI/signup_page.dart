import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mytestapp/UI/login_page.dart';
import 'package:mytestapp/services/signup.dart';

class SignUPPage extends StatefulWidget {
  SignUPPage({Key? key}) : super(key: key);

  @override
  _SignUPPageState createState() => _SignUPPageState();
}

class _SignUPPageState extends State<SignUPPage> {
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  List<String> listMail = [];

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection("Users")
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.forEach((document) {
                listMail.add(document["Email"]);
              })
            });
    // TODO: implement initState
    super.initState();
  }

  final formKey = GlobalKey<FormState>();
  late String name, email, pass, line;
  late bool _check = false;

  checkemail(String email) async {
    //print(email);
    for (var i in listMail) {
      if (i == email) {
        _check = true;
      }
    }
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
                    height: size.height * 0.25,
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
                    height: size.height * 0.75,
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
                                  TextStyle(fontSize: 30, color: Colors.white),
                            ),
                          ),
                          const Text(
                            "Sign up to continue",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "กรุณาใส่ชื่อ";
                              }
                            },
                            style: const TextStyle(color: Colors.white),
                            onSaved: (value) => setState(() => name = value!),
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.person_pin,
                                  color: Colors.yellow,
                                ),
                                labelText: "Name",
                                //hintText: "Input password",
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(5.0))),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "กรุณาใส่ไลน์ไอดี";
                              }
                            },
                            style: const TextStyle(color: Colors.white),
                            onSaved: (value) => setState(() => line = value!),
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.phone_android,
                                  color: Colors.yellow,
                                ),
                                labelText: "LinID",
                                //hintText: "Input password",
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(5.0))),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "กรุณาใส่อีเมล";
                              } else {
                                bool emailValid = RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value);
                                if (emailValid == false) {
                                  return "รูปแบบอีเมลไม่ถูกต้อง";
                                } else {
                                  checkemail(value);
                                  print(_check);
                                  if (_check == true) {
                                    _check = false;
                                    //print("Mail validator");
                                    return "อีเมลนี้ใช้ไปแล้ว";
                                  }
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
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "กรุณาใส่รหัสผ่าน";
                              }
                            },
                            obscureText: true,
                            style: const TextStyle(color: Colors.white),
                            onSaved: (value) =>
                                setState(() => pass = value!),
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
                          ),
                          SizedBox(
                            height: size.height * 0.05,
                          ),
                          SizedBox(
                            width: size.width * 0.95,
                            height: size.height * 0.05,
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context,
                                      MaterialPageRoute(builder: (context) {
                                    return LoginPage();
                                  }));
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white, // background
                                  onPrimary:
                                      const Color(0xFF025564), // foreground
                                ),
                                child: const Text("Login")),
                          ),
                          const Text(
                            "Or",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(
                            width: size.width * 0.95,
                            height: size.height * 0.05,
                            child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    print("Sign Up!!!");
                                    formKey.currentState!.save();
                                    Signup().signup(name, line, email, pass);
                                    formKey.currentState!.reset();
                                    Navigator.pop(context,
                                        MaterialPageRoute(builder: (context) {
                                      return LoginPage();
                                    }));
                                  }
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
