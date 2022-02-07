import 'package:cloud_firestore/cloud_firestore.dart';

class log_in{
  getUser(String username, String password){
    //ap<String,String>userdata={'name':"Satang"};
    return FirebaseFirestore.instance
            .collection("Users")
            .where("Email", isEqualTo: username)
            .where("Password", isEqualTo: password)
            .get();
  }
}