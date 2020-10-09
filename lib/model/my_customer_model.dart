class MyCustomerModel {
  Data data;
  int status;
  String code;
  String info;

  MyCustomerModel({this.data, this.status, this.info,this.code});

  MyCustomerModel.fromJson(Map<String, dynamic> json) {
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
  String total;
  int pagesize;
  int pageindex;
  List<DataList> list;
  String pagenum;
  bool ispage;

  Data(
      {this.total,
        this.pagesize,
        this.pageindex,
        this.list,
        this.pagenum,
        this.ispage});

  Data.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    pagesize = json['pagesize'];
    pageindex = json['pageindex'];
    if (json['list'] != null) {
      list = List<DataList>();
      json['list'].forEach((v) {
        list.add(new DataList.fromJson(v));
      });
    }
    pagenum = json['pagenum'];
    ispage = json['ispage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['pagesize'] = this.pagesize;
    data['pageindex'] = this.pageindex;
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    data['pagenum'] = this.pagenum;
    data['ispage'] = this.ispage;
    return data;
  }
}

class DataList {
  String area;
  int characters;
  String address;
  String province;
  String color;
  int userId;
  String city;
  String userName;
  int sex;
  String tel;
  int id;
  String brand;

  DataList(
      {this.area,
        this.characters,
        this.address,
        this.province,
        this.color,
        this.userId,
        this.city,
        this.userName,
        this.sex,
        this.tel,
        this.id,
        this.brand});

  DataList.fromJson(Map<String, dynamic> json) {
    area = json['area'];
    characters = json['characters'];
    address = json['address'];
    province = json['province'];
    color = json['color'];
    userId = json['user_id'];
    city = json['city'];
    userName = json['user_name'];
    sex = json['sex'];
    tel = json['tel'];
    id = json['id'];
    brand = json['brand'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['area'] = this.area;
    data['characters'] = this.characters;
    data['address'] = this.address;
    data['province'] = this.province;
    data['color'] = this.color;
    data['user_id'] = this.userId;
    data['city'] = this.city;
    data['user_name'] = this.userName;
    data['sex'] = this.sex;
    data['tel'] = this.tel;
    data['id'] = this.id;
    data['brand'] = this.brand;
    return data;
  }
}
