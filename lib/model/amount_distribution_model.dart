//单量和实收金额分布
class AmountDistributionModel {
  Data data;
  int status;
  String code;
  String info;

  AmountDistributionModel({this.data, this.status, this.code, this.info});

  AmountDistributionModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    status = json['status'];
    code = json['code'];
    info = json['info'];
  }
}

class Data {
  double moneyBlock;
  Query query;
  double numBlock;
  Map<String, dynamic> moneyMap;
  Map<String, dynamic> numMap;

  Data(
      {this.moneyBlock, this.query, this.numBlock, this.moneyMap, this.numMap});

  Data.fromJson(Map<String, dynamic> json) {
    moneyBlock = json['money_block'];
    query = json['query'] != null ? new Query.fromJson(json['query']) : null;
    numBlock = double.parse(json['num_block'].toString());
    moneyMap = json['moneyMap'];
    numMap = json['numMap'];
  }
}

class Query {
  String numSum;
  String realpriceSum;
  String num;
  String realprice;

  Query({this.numSum, this.realpriceSum, this.num, this.realprice});

  Query.fromJson(Map<String, dynamic> json) {
    numSum = json['num_sum'];
    realpriceSum = json['realprice_sum'];
    num = json['num'];
    realprice = json['realprice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['num_sum'] = this.numSum;
    data['realprice_sum'] = this.realpriceSum;
    data['num'] = this.num;
    data['realprice'] = this.realprice;
    return data;
  }
}
