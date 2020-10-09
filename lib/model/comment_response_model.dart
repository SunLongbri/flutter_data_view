//通用数据返回模型
class CommentResponseModel {
  int status;
  String code;
  String info;

  CommentResponseModel({this.status, this.info,this.code});

  CommentResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    info = json['info'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['info'] = this.info;
    return data;
  }
}
