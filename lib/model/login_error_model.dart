//登陆失败模型
class LoginErrorModel {
  String password;
  int code;
  String message;
  String account;

  LoginErrorModel({this.password, this.code, this.message, this.account});

  LoginErrorModel.fromJson(Map<String, dynamic> json) {
    password = json['password'];
    code = json['code'];
    message = json['message'];
    account = json['account'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['password'] = this.password;
    data['code'] = this.code;
    data['message'] = this.message;
    data['account'] = this.account;
    return data;
  }
}
