class GooglePlacesItemTermModel {
  int offset;
  String value;

  GooglePlacesItemTermModel({this.offset, this.value});

  factory GooglePlacesItemTermModel.fromJson(Map<String, dynamic> json){
    return GooglePlacesItemTermModel (
        offset : json['offset'],
        value : json['value'],);
  }
}
