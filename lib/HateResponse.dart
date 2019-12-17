class HateResponse {
  String firstName;
  String secondName;
  String percentage;
  String result;

  HateResponse({this.firstName, this.secondName, this.percentage, this.result});

  factory HateResponse.fromJson(Map<String, dynamic> parsedJson){
    return HateResponse(
        firstName: parsedJson['fname'],
        secondName : parsedJson['sname'],
        percentage : parsedJson ['percentage'],
        result: parsedJson['result']
    );
  }
}
