
class UsersLoggedModel {
  String id;
  String created;
  int ttl;
  int userId;
  UsersLoggedModel({this.id, this.created, this.ttl, this.userId});

  factory UsersLoggedModel.fromJson(Map<String, dynamic> json) {
    return UsersLoggedModel(
      id: json["id"],
      created: json["created"],
      ttl: json["ttl"],
      userId: json["userId"],);
  }
}
