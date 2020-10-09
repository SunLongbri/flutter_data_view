//网点管理报表 小哥营销情况 数据模型
class DeliverBusinessModel {
  List<BussinessData> data;
  String pagesize;
  String pageindex;
  bool ispage;
  int status;
  String code;
  String info;

  DeliverBusinessModel(
      {this.data,
        this.pagesize,
        this.pageindex,
        this.ispage,
        this.status,
        this.code,
        this.info});

  DeliverBusinessModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<BussinessData>();
      json['data'].forEach((v) {
        data.add(new BussinessData.fromJson(v));
      });
    }
    pagesize = json['pagesize'];
    pageindex = json['pageindex'];
    ispage = json['ispage'];
    code = json['code'];
    status = json['status'];
    info = json['info'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['pagesize'] = this.pagesize;
    data['pageindex'] = this.pageindex;
    data['ispage'] = this.ispage;
    data['status'] = this.status;
    data['info'] = this.info;
    return data;
  }
}

class BussinessData {
  double price;
  String xiaoge;
  int count;
  double commission;
  String type;

  BussinessData({this.price, this.xiaoge, this.count, this.commission, this.type});

  BussinessData.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    xiaoge = json['xiaoge'];
    count = json['count'];
    commission = json['commission'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['xiaoge'] = this.xiaoge;
    data['count'] = this.count;
    data['commission'] = this.commission;
    data['type'] = this.type;
    return data;
  }
}
