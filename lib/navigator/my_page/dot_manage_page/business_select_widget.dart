import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/login/login_page.dart';
import 'package:fluttermarketingplus/model/deliver_business_model.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/alert_dialog_widget.dart';
import 'package:fluttermarketingplus/widgets/item_title_widget.dart';
import 'package:fluttermarketingplus/widgets/loading_container.dart';
import 'package:fluttermarketingplus/widgets/single_select_rectangle_widget.dart';
import 'package:oktoast/oktoast.dart';

//小哥营销情况组件
class BussinessSelectWidget extends StatefulWidget {
  @override
  _BussinessSelectWidgetState createState() => _BussinessSelectWidgetState();
}

class _BussinessSelectWidgetState extends State<BussinessSelectWidget> {
  //用户选择的类型
  String type;

  //是否加载书记处
  bool _isLoading;

  //小哥营销情况数据
  List<BussinessData> dataList;
  bool _loadData;

  @override
  void initState() {
    type = '1';
    _loadData = true;
    _isLoading = false;
    _initDeliverBusinessData();
    super.initState();
  }

  //初始化小哥营销情况数据
  void _initDeliverBusinessData() {
    dataList = [];
    Map<String, String> params = {
      'user_id': '461',
      'type': type,
      'pageindex': "1",
      'pagesize': '1000'
    };
    setState(() {
      _isLoading = true;
    });
    getRequest(API.DELIVER_BUSINESS_ENV, queryParameters: params).then((val) {
      if (!_loadData) {
        return;
      }
      setState(() {
        _isLoading = false;
      });
      print('val:${val}');
      DeliverBusinessModel deliverBusinessModel =
          DeliverBusinessModel.fromJson(val);
      if (deliverBusinessModel.code == GlobalData.UNAUTHORIZED_TOKEN) {
        //token失效
        AlertDialogWidget(title: '登陆过期,请重新登陆!').show(context).then((val) {
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => route == null);
        });
      } else if (deliverBusinessModel.status == GlobalData.REQUEST_SUCCESS) {
        //数据返回成功
        setState(() {
          dataList = deliverBusinessModel.data;
        });
      } else {
        showToast('网络开小车了,请稍后再试!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingContainer(
      marginTop: 300,
      cover: true,
      isLoading: _isLoading,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            ItemTitleWidget(
              '小哥营销情况',
              marginTop: 10,
            ),
            SingleSelectRectangleWidget(
              listContent: ['鲜花', '洗涤'],
              stringBlock: (val) {
                print('用户选择的数据为:${val}');
                setState(() {
                  if (val.compareTo('鲜花') == 0) {
                    type = '1';
                  } else if (val.compareTo('洗涤') == 0) {
                    type = '2';
                  }
                });
                _initDeliverBusinessData();
              },
            ),
            Container(
              padding: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom: BorderSide(color: ColorConstant.greyLineColor))),
              child: Row(
                children: [
                  _singleTitleWidget('小哥', 2),
                  _singleTitleWidget('订单量', 2),
                  _singleTitleWidget('实收金额', 2),
                  _singleTitleWidget('佣金', 2),
                ],
              ),
            ),
            Container(
              height: AutoLayout.instance.pxToDp(270),
              child: ListView.builder(
//                  physics: NeverScrollableScrollPhysics(), //禁止滑动
                  itemCount: dataList.length,
//                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int position) {
                    double price = dataList[position].price;
                    String name = dataList[position].xiaoge;
                    int count = dataList[position].count;
                    double commission = dataList[position].commission;
                    return _singleLieData(
                        name, '${count}单', '¥${price}', '¥${commission}');
                  }),
            )
          ],
        ),
      ),
    );
  }

  //单行数据组件
  Widget _singleLieData(
      String name, String orderCount, String totalMoney, String getMoney) {
    return Container(
//      height: AutoLayout.instance.pxToDp(137),
      padding: EdgeInsets.only(
//          left: ScreenUtil().setWidth(28),
          right: ScreenUtil().setWidth(10),
          top: AutoLayout.instance.pxToDp(26),
          bottom: AutoLayout.instance.pxToDp(26)),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(color: ColorConstant.greyLineColor))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              _singleTextWidget(name, 2),
              _singleTextWidget(orderCount, 2),
              _singleTextWidget(totalMoney, 2),
              _singleTextWidget(getMoney, 2)
            ],
          ),
        ],
      ),
    );
  }

  //单元格单行文字样式
  Widget _singleTextWidget(String content, int flex) {
    return Expanded(
        flex: flex,
        child: Container(
          alignment: Alignment.center,
          child: Text(
            content,
            style: TextStyle(
                color: ColorConstant.greyTextColor,
                fontSize: ScreenUtil().setSp(28)),
          ),
        ));
  }

  //标题单个控制格
  Widget _singleTitleWidget(String title, int flex) {
    return Expanded(
        flex: flex,
        child: Container(
          height: AutoLayout.instance.pxToDp(73),
          alignment: Alignment.center,
          padding: EdgeInsets.only(
              top: AutoLayout.instance.pxToDp(10),
              bottom: AutoLayout.instance.pxToDp(10)),
          child: Container(
            child: Text(
              title,
              style: TextStyle(
                  color: ColorConstant.blackTextColor,
                  fontSize: ScreenUtil().setSp(30)),
            ),
          ),
        ));
  }
}
