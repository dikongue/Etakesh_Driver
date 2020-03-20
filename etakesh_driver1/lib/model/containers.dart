
class ContainersModel {
  String name;
  String atime;
  String mtime;
  String ctime;
  double size;

  ContainersModel({this.name, this.atime, this.mtime, this.ctime, this.size});

  factory ContainersModel.fromJson(Map<String, dynamic> json) {
    return ContainersModel(
        name: json["name"],
        atime: json["atime"],
        mtime: json["mtime"],
        ctime: json["ctime"],
        size: double.parse('${json["size"]}'));
  }
}
