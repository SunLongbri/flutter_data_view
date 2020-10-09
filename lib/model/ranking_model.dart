//企业好评率排行
class RankingModel {
  List<Alldata> laundrydata;
  List<Alldata> alldata;
  String code;
  List<Alldata> productdata;

  RankingModel({this.laundrydata, this.alldata, this.code, this.productdata});

  RankingModel.fromJson(Map<String, dynamic> json) {
    if (json['laundrydata'] != null) {
      laundrydata = new List<Alldata>();
      json['laundrydata'].forEach((v) {
        laundrydata.add(new Alldata.fromJson(v));
      });
    }
    if (json['alldata'] != null) {
      alldata = new List<Alldata>();
      json['alldata'].forEach((v) {
        alldata.add(new Alldata.fromJson(v));
      });
    }
    code = json['code'];
    if (json['productdata'] != null) {
      productdata = new List<Alldata>();
      json['productdata'].forEach((v) {
        productdata.add(new Alldata.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.laundrydata != null) {
      data['laundrydata'] = this.laundrydata.map((v) => v.toJson()).toList();
    }
    if (this.alldata != null) {
      data['alldata'] = this.alldata.map((v) => v.toJson()).toList();
    }
    data['code'] = this.code;
    if (this.productdata != null) {
      data['productdata'] = this.productdata.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Alldata {
  String payMoney2;
  String payMoney1;
  String pickupStoreName;
  String pickupStoreCode;
  String payMoney;

  Alldata(
      {this.payMoney2,
      this.payMoney1,
      this.pickupStoreName,
      this.pickupStoreCode,
      this.payMoney});

  Alldata.fromJson(Map<String, dynamic> json) {
    payMoney2 = json['pay_money2'];
    payMoney1 = json['pay_money1'];
    pickupStoreName = json['pickup_store_name'];
    pickupStoreCode = json['pickup_store_code'];
    payMoney = json['pay_money'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pay_money2'] = this.payMoney2;
    data['pay_money1'] = this.payMoney1;
    data['pickup_store_name'] = this.pickupStoreName;
    data['pickup_store_code'] = this.pickupStoreCode;
    data['pay_money'] = this.payMoney;
    return data;
  }
}
