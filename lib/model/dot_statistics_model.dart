//网点管理报表 - 数据统计
class DotStaticsModel {
  List<Data> data;
  int status;
  String info;
  String code;

  DotStaticsModel({this.data, this.status, this.info,this.code});

  DotStaticsModel.fromJson(Map<String, dynamic> json) {
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
  String empid;
  String rate;
  String nickname;
  String myCustomer;
  String village;
  String customer;

  Data(
      {this.empid,
      this.rate,
      this.nickname,
      this.myCustomer,
      this.village,
      this.customer});

  Data.fromJson(Map<String, dynamic> json) {
    empid = json['empid'];
    rate = json['rate'];
    nickname = json['nickname'];
    myCustomer = json['my_customer'];
    village = json['village'];
    customer = json['customer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empid'] = this.empid;
    data['rate'] = this.rate;
    data['nickname'] = this.nickname;
    data['my_customer'] = this.myCustomer;
    data['village'] = this.village;
    data['customer'] = this.customer;
    return data;
  }
}
