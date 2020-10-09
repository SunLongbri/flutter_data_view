//任务达成率数据模型
class MyTaskRateModel {
  Data data;
  int status;
  String code;
  String info;

  MyTaskRateModel({this.data, this.status, this.info,this.code});

  MyTaskRateModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    status = json['status'];
    info = json['info'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['status'] = this.status;
    data['info'] = this.info;
    return data;
  }
}

class Data {
  String ratio;

  Data({this.ratio});

  Data.fromJson(Map<String, dynamic> json) {
    ratio = json['ratio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ratio'] = this.ratio;
    return data;
  }
}
