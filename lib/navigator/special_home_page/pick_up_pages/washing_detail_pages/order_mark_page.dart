import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/model/response_model.dart';
import 'package:fluttermarketingplus/navigator/special_home_page/pick_up_pages/washing_detail_pages/mark_history_page.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';
import 'package:fluttermarketingplus/widgets/loading_container.dart';
import 'package:fluttermarketingplus/widgets/text_area_widget/callback_method.dart';
import 'package:fluttermarketingplus/widgets/text_area_widget/text_area.dart';
import 'package:oktoast/oktoast.dart';

//订单备注页面
class OrderMarkPage extends StatefulWidget {
  final String orderId;

  const OrderMarkPage({Key key, this.orderId}) : super(key: key);

  @override
  _OrderMarkPageState createState() => _OrderMarkPageState();
}

class _OrderMarkPageState extends State<OrderMarkPage>
    implements OnStatusChangeListener {
  TextEditingController _textAreaEditController;
  String _markStr;
  bool _isLoading;

  @override
  void initState() {
    _textAreaEditController = TextEditingController();
    _markStr = '';
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '订单备注',
        actionPress: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => MarkHistoryPage(orderId: widget.orderId,)));
        },
        actionsWidget: Container(
          width: ScreenUtil().setWidth(54),
          child: Image.asset(
            'images/history_icon.png',
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
      body: LoadingContainer(
          isLoading: _isLoading,
          cover: true,
          child: Container(
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(20),
              right: ScreenUtil().setWidth(20),
            ),
            child: Column(
              children: <Widget>[
                TextArea(
                  marginTop: 30,
                  textEditingController: _textAreaEditController,
                  hintText: '请输入备注(一共可以输入200个字)',
                  onStatusChangeListener: this,
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      top: AutoLayout.instance.pxToDp(60),
                      left: ScreenUtil().setWidth(60),
                      right: ScreenUtil().setWidth(60)),
                  child: FractionallySizedBox(
                    widthFactor: 1,
                    child: FlatButton(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        color: ColorConstant.blueBgColor,
                        onPressed: () {
                          _orderMark();
                        },
                        child: Text(
                          '提交',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(30)),
                        )),
                  ),
                )
              ],
            ),
          )),
    );
  }

  _orderMark() {
    var now = new DateTime.now();
    if (_markStr.isEmpty) {
      showToast('请填写备注信息！');
      return;
    }
    var formData = {
      "orderId": widget.orderId,
      "orderType": "2",
      "markTime": now.toString().split('.')[0],
      "markContent": _markStr
    };
    setState(() {
      _isLoading = true;
    });
    postRequest(API.ORDER_MARK, formData, tempBaseUrl: API.TEST_BASE_URL)
        .then((value) {
      setState(() {
        _isLoading = false;
      });
      print('修改备注参数为:${formData}');
      print('val:${value}');
      ResponseModel responseModel = ResponseModel.fromJson(value);
      if (responseModel.code == 200) {
        if (responseModel.message.contains('成功')) {
          showToast('修改备注成功!');
          Navigator.pop(context);
        } else {
          showToast(responseModel.message);
        }
      }
    });
  }

  @override
  void onStatesComplete(String commitText) {
    setState(() {
      _markStr = commitText;
    });
  }
}
