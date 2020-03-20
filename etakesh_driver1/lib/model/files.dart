
class FilesModel {
  String container;
  String name;
  String atime;
  String mtime;
  String ctime;
  double size;

  FilesModel({this.container, this.name, this.atime, this.mtime, this.ctime, this.size});

  factory FilesModel.fromJson(Map<String, dynamic> json) {
    return FilesModel(
        container: json["container"],
        name: json["name"],
        atime: json["atime"],
        mtime: json["mtime"],
        ctime: json["ctime"],
        size: double.parse('${json["size"]}'));
  }
}
