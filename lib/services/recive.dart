import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class recive {
  recived(String id,String userid) {
    //print('No image selected.');
    FirebaseFirestore.instance.collection("Jobs").doc(id).update({
      "Status": "Recived",
      "Recive": userid,
    });
  }
}
