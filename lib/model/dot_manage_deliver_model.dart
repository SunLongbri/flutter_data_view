//网点管理报表 查询小哥返回数据模型
class DotManageDeliverModel {
  List<Data> data;
  int status;
  String code;
  String info;

  DotManageDeliverModel({this.data, this.status, this.info,this.code});

  DotManageDeliverModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    status = json['status'];
    code = json['code'];
    info = json['info'];
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
  String userId;
  String stationId;
  String nickname;
  String account;

  Data({this.userId, this.stationId, this.nickname, this.account});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    stationId = json['station_id'];
    nickname = json['nickname'];
    account = json['account'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['station_id'] = this.stationId;
    data['nickname'] = this.nickname;
    data['account'] = this.account;
    return data;
  }
}


class DeliverData {
  String address;
  String userName;
  String sex;
  String tel;

  DeliverData({this.address, this.userName, this.sex, this.tel});

  DeliverData.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    userName = json['user_name'];
    sex = json['sex'];
    tel = json['tel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['user_name'] = this.userName;
    data['sex'] = this.sex;
    data['tel'] = this.tel;
    return data;
  }
}
