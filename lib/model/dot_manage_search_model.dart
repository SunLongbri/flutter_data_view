//网点管理查询数据返回模型
class DotManageSearchModel {
  List<SearchData> data;
  int status;
  String code;
  String info;

  DotManageSearchModel({this.data, this.status, this.info,this.code});

  DotManageSearchModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<SearchData>();
      json['data'].forEach((v) {
        data.add(new SearchData.fromJson(v));
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

class SearchData {
  String address;
  String userName;
  String sex;
  String tel;

  SearchData({this.address, this.userName, this.sex, this.tel});

  SearchData.fromJson(Map<String, dynamic> json) {
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
