class FavoritData {
  String? id;
  String? userid;
  String? lodgeid;

  FavoritData({required this.id, required this.lodgeid, required this.userid});

  FavoritData.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    userid = map['userid'];
    lodgeid = map['lodgeid'];
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'userid': userid, 'lodgeid': lodgeid};
  }
}
