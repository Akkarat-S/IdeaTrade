import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mytestapp/model/user_model.dart';

class Login {
  UserModel user = UserModel(
      ID: '',
      Email: '',
      Password: '',
      Name: '',
      LineID: '',
      Image: '',
      Role: '');
  UserModel login(String email, String password) {
    print("Email:$email\nPassword:$password");
    FirebaseFirestore.instance
        .collection("Users")
        .where("Email", isEqualTo: email)
        .where("Password", isEqualTo: password)
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.forEach((document) {
                print(document.id);
                user.ID = document.id;
                //print(document["Email"]);
                user.Email = document["Email"];
                //print(document["Password"]);
                user.Password = document["Password"];
                //print(document["Name"]);
                user.Name = document["Name"];
                //print(document["LineID"]);
                user.LineID = document["LineID"];
                //print(document["Image"]);
                user.Image = document["Image"];
                //print(document["Role"]);
                user.Role = document["Role"];
              })
            });
    return user;
  }
}
