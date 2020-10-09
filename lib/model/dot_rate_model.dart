//达成率 数据模型
class DotRateModel {
  List<Data> data;
  int status;
  String info;
  String code;

  DotRateModel({this.data, this.status, this.info,this.code});

  DotRateModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    status = json['status'];
    info = json['info'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['info'] = this.info;
    return data;
  }
}

class Data {
  String sub;
  String rate;

  Data({this.sub, this.rate});

  Data.fromJson(Map<String, dynamic> json) {
    sub = json['sub'];
    rate = json['rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sub'] = this.sub;
    data['rate'] = this.rate;
    return data;
  }
}
