//我的 - 客户详情修改用户信息上传模型
class CustomerDetailUploadModel {
  String id;
  String userName;
  String sex;
  String tel;
  String province;
  String city;
  String area;
  String address;
  String color;
  String characters;
  String brand;

  CustomerDetailUploadModel(
      {this.id,
        this.userName,
        this.sex,
        this.tel,
        this.province,
        this.city,
        this.area,
        this.address,
        this.color,
        this.characters,
        this.brand});

  CustomerDetailUploadModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['user_name'];
    sex = json['sex'];
    tel = json['tel'];
    province = json['province'];
    city = json['city'];
    area = json['area'];
    address = json['address'];
    color = json['color'];
    characters = json['characters'];
    brand = json['brand'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_name'] = this.userName;
    data['sex'] = this.sex;
    data['tel'] = this.tel;
    data['province'] = this.province;
    data['city'] = this.city;
    data['area'] = this.area;
    data['address'] = this.address;
    data['color'] = this.color;
    data['characters'] = this.characters;
    data['brand'] = this.brand;
    return data;
  }
}
