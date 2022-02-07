class UserModel {
  String ID;
  String Name;
  String LineID;
  String Email;
  String Password;
  String Image;
  String Role;

  UserModel(
      {required this.ID,
      required this.Name,
      required this.LineID,
      required this.Email,
      required this.Password,
      required this.Image,
      required this.Role});
}
