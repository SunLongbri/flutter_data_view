import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/login/login_page.dart';
import 'package:fluttermarketingplus/model/my_code_model.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/alert_dialog_widget.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';
import 'package:oktoast/oktoast.dart';
import 'package:qr_flutter/qr_flutter.dart';

/**
 * 我的二维码
 */
class MyCanvaPage extends StatefulWidget {
  final String titleData;

  const MyCanvaPage({Key key, this.titleData}) : super(key: key);

  @override
  _MyCanvaPageState createState() => _MyCanvaPageState();
}

class _MyCanvaPageState extends State<MyCanvaPage> {
  //我的二维码URL
  String _codeUrl = 'https://m.24tidy.com?id=';

  @override
  void initState() {
    //获取小哥的工号
    getRequest(API.MY_CODE_ID).then((val) {
      MyCodeModel myCodeModel = MyCodeModel.fromJson(val);
      if (myCodeModel.code == GlobalData.UNAUTHORIZED_TOKEN) {
        //token失效
        AlertDialogWidget(title: '登陆过期,请重新登陆!').show(context).then((val) {
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => route == null);
        });
      } else if (myCodeModel.status == GlobalData.REQUEST_SUCCESS) {
        //数据返回正常
        String _devilderId = myCodeModel.data;
        setState(() {
          _codeUrl = '${_codeUrl}${_devilderId}';
        });
      } else {
        showToast('网络开小车了,请稍后再试!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '我的二维码',
      ),
      body: Container(
        alignment: Alignment.topCenter,
        color: ColorConstant.greyBgColor,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(
              left: 18.0, right: 18.0, top: 22.0, bottom: 193),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            color: Colors.white,
          ),
          child: Column(
            children: <Widget>[
              Container(
                height: AutoLayout.instance.pxToDp(118),
                alignment: Alignment.center,
                child: Text(
                  "小哥二维码",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: ScreenUtil().setSp(32),
                  ),
                ),
              ),
              Divider(
                height: ScreenUtil().setHeight(1),
                color: ColorConstant.greyTextColor,
              ),
              SizedBox(
                height: ScreenUtil().setHeight(66),
              ),
              QrImage(
                data: _codeUrl,
                version: QrVersions.auto,
                size: 200.0,
              ),
              SizedBox(
                height: ScreenUtil().setHeight(37),
              ),
              GestureDetector(
                onLongPress: () {
                  showToast('已复制到剪贴版');
                  Clipboard.setData(ClipboardData(text: _codeUrl));
                },
                child: Text(
                  "h5链接：${_codeUrl}",
                  style: TextStyle(
                    color: ColorConstant.greyTextColor,
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
