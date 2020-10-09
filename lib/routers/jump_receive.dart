import 'dart:convert';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'application.dart';

class JumpReceive {
  //context : 跳转之前页面的上下文
  //destination : 跳转到哪个页面
  //paramsName : 跳转页面携带的参数的名字
  //sendData : 跳转页面携带的参数
  Future<String> jump(BuildContext context, String destination,
      {String paramsName = '',
      String sendData = '',
      String secondParamsName = '',
      String sendSecondData = '',
      TransitionType type = TransitionType.native}) async {
    if (paramsName.isEmpty || sendData.isEmpty) {
      return await Application.router
          .navigateTo(context, destination, transition: type);
    } else if (secondParamsName.isEmpty || sendSecondData.isEmpty) {
      String params = jsonEncode(Utf8Encoder().convert(sendData.trim()));
      return await Application.router.navigateTo(
          context, '${destination}?${paramsName}=${params}',
          transition: type);
    } else {
      String params1 = jsonEncode(Utf8Encoder().convert(sendData.trim()));
      String params2 = jsonEncode(Utf8Encoder().convert(sendSecondData.trim()));
      return await Application.router.navigateTo(context,
          '${destination}?${paramsName}=${params1}&${secondParamsName}=${params2}',
          transition: type);
    }
  }

  //dataListStr : 接收的参数   [104,104,104,104]
  String receive(String dataListStr) {
    var list = List<int>();
    jsonDecode(dataListStr).forEach(list.add);
    return Utf8Decoder().convert(list);
  }
}
