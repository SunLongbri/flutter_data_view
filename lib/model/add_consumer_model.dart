//添加客户信息
class AddConsumerModel {
  String userId;
  String userName;
  String sex;
  String tel;
  String province;
  String city;
  String area;
  String address;
  String color;
  String character;
  String brand;

  AddConsumerModel(
      {this.userId,
        this.userName,
        this.sex,
        this.tel,
        this.province,
        this.city,
        this.area,
        this.address,
        this.color,
        this.character,
        this.brand});

  AddConsumerModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    sex = json['sex'];
    tel = json['tel'];
    province = json['province'];
    city = json['city'];
    area = json['area'];
    address = json['address'];
    color = json['color'];
    character = json['character'];
    brand = json['brand'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['sex'] = this.sex;
    data['tel'] = this.tel;
    data['province'] = this.province;
    data['city'] = this.city;
    data['area'] = this.area;
    data['address'] = this.address;
    data['color'] = this.color;
    data['character'] = this.character;
    data['brand'] = this.brand;
    return data;
  }
}
