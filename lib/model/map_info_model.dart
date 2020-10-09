//地图信息展示模型
class MapInfoModel {
  int code;
  Data data;

  MapInfoModel({this.code, this.data});

  MapInfoModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String userNum;
  String address;
  String lng;
  String userFuGai;
  String xiaoQu;
  String goodUser;
  String id;
  String lat;
  String quality;

  Data(
      {this.userNum,
        this.address,
        this.lng,
        this.userFuGai,
        this.xiaoQu,
        this.goodUser,
        this.id,
        this.lat,
        this.quality});

  Data.fromJson(Map<String, dynamic> json) {
    userNum = json['user_num'];
    address = json['address'];
    lng = json['lng'];
    userFuGai = json['user_fu_gai'];
    xiaoQu = json['xiao_qu'];
    goodUser = json['good_user'];
    id = json['id'];
    lat = json['lat'];
    quality = json['quality'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_num'] = this.userNum;
    data['address'] = this.address;
    data['lng'] = this.lng;
    data['user_fu_gai'] = this.userFuGai;
    data['xiao_qu'] = this.xiaoQu;
    data['good_user'] = this.goodUser;
    data['id'] = this.id;
    data['lat'] = this.lat;
    data['quality'] = this.quality;
    return data;
  }
}
