import 'package:flutter/cupertino.dart';

//新增任务单行数据
class UserData {
  String userId;
  String stationId;
  String nickname;
  String account;

  //鲜花单量控制器
  TextEditingController flowerCountController;

  //鲜花实收金额
  TextEditingController flowerRealMoneyController;

  //洗涤单量
  TextEditingController washCountController;

  //洗涤实收金额
  TextEditingController washRealMoneyController;

  UserData(
      {this.userId,
      this.stationId,
      this.nickname,
      this.account,
      this.flowerCountController,
      this.flowerRealMoneyController,
      this.washCountController,
      this.washRealMoneyController});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['station_id'] = this.stationId;
    data['nickname'] = this.nickname;
    data['account'] = this.account;
    return data;
  }
}
