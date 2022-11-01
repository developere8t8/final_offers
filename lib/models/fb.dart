class FaceBookLoginInfo {
  String? name;
  String? fname;
  String? lname;
  String? email;
  String? id;

  FaceBookLoginInfo(
      {required this.email,
      required this.fname,
      required this.id,
      required this.lname,
      required this.name});

  FaceBookLoginInfo.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    fname = map['first_name'];
    lname = map['last_name'];
    email = map['email'];
    id = map['id'];
  }
}
