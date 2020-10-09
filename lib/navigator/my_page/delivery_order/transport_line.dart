import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttermarketingplus/routers/jump_receive.dart';
import 'package:fluttermarketingplus/routers/routes.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';
import 'package:oktoast/oktoast.dart';

import '../../../service/API.dart';
import '../../../service/service_method.dart';
///运输线路
///
class TransportLine extends StatefulWidget {
  @override
  _TransportLineState createState() => _TransportLineState();
}

class _TransportLineState extends State<TransportLine> {

  TextEditingController _controller =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '泰笛洗涤',
      ),
      body: Stack (
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          Positioned(
            left: 30,
            top: 50,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.5),
                color: Colors.yellow,
              ),
              height: 100,
              width: 140,
              // color: Colors.yellow,
              child: FlatButton(
                onPressed: (){
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 150.0,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text('手机扫码',textAlign: TextAlign.center),
                              onTap: () {
                                JumpReceive().jump(context, Routes.deliveryOrderScanQrPage).then(
                                  (value){
                                    packageInformationWithCode(context ,value);
                                  }
                                );
                              },
                            ),
                            Container(
                              child: ListTile(
                                title: Text('扫码枪扫码',textAlign: TextAlign.center),
                                onTap: () {
                                  Navigator.pop(context, '扫码枪扫码');
                                  showCupertinoDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: Text('扫码或者手动输入'),
                                      content: Card(
                                        elevation: 0.0,
                                        child: TextField(
                                          controller: _controller,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              hintText: '扫码或者手动输入',
                                              filled: true,
                                              fillColor: Colors.grey.shade50),
                                        ),
                                      ),
                                      actions: <Widget>[
                                        CupertinoDialogAction(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('取消'),
                                        ),
                                        CupertinoDialogAction(
                                          onPressed: () {
//                                            Navigator.pop(context);
                                            print('手动输入》》'+ _controller.text.toString());
                                            packageInformationWithCode(context, _controller.text.toString());
                                          },
                                          child: Text('确定'),
                                        ),
                                      ],
                                    );
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  );
                },
              child: Text('洗前：网点->干线') ),
            )
          ),
          Positioned(
            right: 30,
            top: 50,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.5),
                color: Colors.red,
              ),
              height: 100,
              width: 140,
              // color: Colors.red,
              child: FlatButton(onPressed: (){

              }, child: Text('洗后：工厂->干线') ),
            )
          ),
        ],
      ),
    );
  }

  void packageInformationWithCode(BuildContext context, String code){
//     var queryParameters = {'delivery_order_id': '1000000312795204'};
    var queryParameters = {'delivery_order_id': code};
    postRequest(API.Driver_Receive, queryParameters).then((val) {
      print('返回数据结果》》》》'+val.toString());
      if (val['status'] == 200) {
        var data = val['data'];
        var packageInformation = {
          'storeName':data['info'],
          'packageNumber':data['delivery_order_id'],
          'createdate':data['createdate'],
          'count':data['count'].toString(),
          'attachment_count':data['attachment_count'],
        };
        print('返回数据结果1111》》》》'+val.toString());
        JumpReceive().jump(context, Routes.packageInformation, paramsName: 'packageInformation', sendData: json.encode(packageInformation)).then(
          (volue){
            Navigator.pop(context,'手机扫码');
          }
        );
      }else if (val['status'] == 500) {
        Navigator.pop(context,'手机扫码');
        showToast(val['message']);
      }
    });
  }

}