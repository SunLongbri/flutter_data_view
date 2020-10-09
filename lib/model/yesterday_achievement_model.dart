//网点管理报表 昨日业绩排行数据模型
class YesterdayAchievementModel {
  List<Data> data;
  int status;
  String code;
  String info;

  YesterdayAchievementModel({this.data, this.status, this.info,this.code});

  YesterdayAchievementModel.fromJson(Map<String, dynamic> json) {
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
  String price;
  String count;
  String station;
  String commission;
  String type;

  Data({this.price, this.count, this.station, this.commission, this.type});

  Data.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    count = json['count'];
    station = json['station'];
    commission = json['commission'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['count'] = this.count;
    data['station'] = this.station;
    data['commission'] = this.commission;
    data['type'] = this.type;
    return data;
  }
}
