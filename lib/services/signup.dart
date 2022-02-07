import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Signup {
  CollectionReference usercollection =
      FirebaseFirestore.instance.collection("Users");
  signup(String name, String line, String email, String password) {
    usercollection.doc().set({
      //"ID":"", //myId,
      "Name": name,
      "LineID": line,
      "Email": email,
      "Password": password,
      "Image":
          "https://firebasestorage.googleapis.com/v0/b/testdataapp-d6da7.appspot.com/o/personIcon.jpeg?alt=media&token=de67309a-7a8c-45a4-ac54-8b463323c8b1",
      "Role": "User"
    });
  }
}
