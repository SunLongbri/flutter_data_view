import 'package:flutter/material.dart';
import 'package:fluttermarketingplus/model/wash_type_name_model.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';

mixin GetTypeData {
  void getNextLatLng({String cityName}) {
    var formData = {"cityName": cityName};
    List<Widget> _leftWidgets = [];
    postRequest(API.EXCELLENT_TYPE_NAME, formData).then((value) async {
      WashTypeNameModel _washTypeNameModel = WashTypeNameModel.fromJson(value);
      if (_washTypeNameModel.code == 200) {}
    });
  }
}
