
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class update{
  update(String mail, String name, String line, String image) {

    FirebaseFirestore.instance
        .collection("Users")
        .doc(mail)
        .update({
          "Name":name,
          "LineID":line,
          "Image": image
          });

    }
    
}