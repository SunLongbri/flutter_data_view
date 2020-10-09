class ResponseModel{
  int code;
  String data;
  String message;

  ResponseModel({this.code,this.message,this.data});

  ResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'];
    code = json['code'];
  }
}