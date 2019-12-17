class NameResponse {
  List<String> names;

  NameResponse({this.names});

  NameResponse.fromJson(Map<String, dynamic> json) {
    names = json['names'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['names'] = this.names;
    return data;
  }
}
