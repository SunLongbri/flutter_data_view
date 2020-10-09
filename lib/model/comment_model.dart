//解析json的数据模型层
class CommentModel {
  String states;
  String errorMsg;
  String code;
  String result;

  CommentModel({this.states, this.errorMsg, this.code,this.result});

  CommentModel.fromJson(Map<String, dynamic> json) {
    states = json['states'];
    errorMsg = json['errorMsg'];
    code = json['code'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['states'] = this.states;
    data['errorMsg'] = this.errorMsg;
    data['result'] = this.result;
    return data;
  }
}

class CommentInfoModel {
  int status;
  String code;
  String info;

  CommentInfoModel({this.status, this.info,this.code});

  CommentInfoModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    info = json['info'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['states'] = this.status;
    data['info'] = this.info;
    return data;
  }
}
