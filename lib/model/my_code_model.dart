//小哥-我的二维码数据模型
class MyCodeModel {
  String data;
  int status;
  String code;
  String info;

  MyCodeModel({this.data, this.status, this.info});

  MyCodeModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    status = json['status'];
    info = json['info'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['status'] = this.status;
    data['info'] = this.info;
    return data;
  }
}
