//网点管理报表下 所有小哥的任务情况
class StoreDeliversTaskModel {
  List<Data> data;
  int status;
  String code;
  String info;

  StoreDeliversTaskModel({this.data, this.status, this.info,this.code});

  StoreDeliversTaskModel.fromJson(Map<String, dynamic> json) {
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
  String flowerCount;
  String flowerMoney;
  String userName;

  Data({this.flowerCount, this.flowerMoney, this.userName});

  Data.fromJson(Map<String, dynamic> json) {
    flowerCount = json['count'];
    flowerMoney = json['money'];
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.flowerCount;
    data['money'] = this.flowerMoney;
    data['user_name'] = this.userName;
    return data;
  }
}
