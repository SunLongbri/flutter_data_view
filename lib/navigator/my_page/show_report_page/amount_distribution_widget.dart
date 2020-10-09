import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/login/login_page.dart';
import 'package:fluttermarketingplus/model/amount_distribution_model.dart';
import 'package:fluttermarketingplus/model/ordinal_sales.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/alert_dialog_widget.dart';
import 'package:fluttermarketingplus/widgets/loading_container.dart';
import 'package:fluttermarketingplus/widgets/single_pop_menu_widget.dart';
import 'package:fluttermarketingplus/widgets/single_select_indicator_widget.dart';
import 'package:fluttermarketingplus/widgets/single_select_rectangle_widget.dart';
import 'package:oktoast/oktoast.dart';
import 'amount_distribution_widget/dollar_horizontal_barchart.dart';
import 'amount_distribution_widget/express_horizontal_barchart.dart';

//单量和实收金额分布
class AmountDistributionWidget extends StatefulWidget {
  @override
  _AmountDistributionWidgetState createState() =>
      _AmountDistributionWidgetState();
}

class _AmountDistributionWidgetState extends State<AmountDistributionWidget> {
  //快递单量
  List<OrdinalSales> deliverOrderList;

  //实收金额
  List<OrdinalSales> paidMoneyList;

  //快递量单位
  String deliverUnit;

  //实收金额单位
  String moneyUnit;

  //我的快递单量
  String myDeliverNum;

  //我的实收金额
  String myRealMoney;

  //是否加载数据
  bool _isLoading;

  //1，鲜花 ，2洗涤
  String type;

  //1 昨日 2 上周； 3 上月；4 上季度
  String flag;

  //1,门店，2城市，3全国
  String area;

  @override
  void initState() {
    type = '1';
    flag = '1';
    area = '1';
    _isLoading = false;
    myRealMoney = '';
    myDeliverNum = '';
    moneyUnit = '';
    deliverUnit = '';
    deliverOrderList = [
      OrdinalSales('0-0', 0),
      OrdinalSales('0-0', 0),
      OrdinalSales('0-0', 0),
      OrdinalSales('0-0', 0),
      OrdinalSales('0-0', 0),
    ];
    paidMoneyList = [
      OrdinalSales('0-0', 0),
      OrdinalSales('0-0', 0),
      OrdinalSales('0-0', 0),
      OrdinalSales('0-0', 0),
      OrdinalSales('0-0', 0),
    ];
    _getAmountData(type, flag, area);
    super.initState();
  }

  //快递和实收金额
  _getAmountData(String type, String flag, String area) {
    print('请求的参数为:type:${type},flag:${flag},area:${area}');
    Map<String, String> parameter = {
      'type': type,
      'flag': flag,
      'area': area,
      'user_id': '1314'
    };
    setState(() {
      _isLoading = true;
      moneyUnit = '';
      deliverUnit = '';
      deliverOrderList = [
        OrdinalSales('0-0', 0),
        OrdinalSales('0-0', 0),
        OrdinalSales('0-0', 0),
        OrdinalSales('0-0', 0),
        OrdinalSales('0-0', 0),
      ];
      paidMoneyList = [
        OrdinalSales('0-0', 0),
        OrdinalSales('0-0', 0),
        OrdinalSales('0-0', 0),
        OrdinalSales('0-0', 0),
        OrdinalSales('0-0', 0),
      ];
    });
    getRequest(API.AMOUNT_DISTRIBUTION, queryParameters: parameter).then((val) {
      setState(() {
        _isLoading = false;
      });
      AmountDistributionModel amountDistributionModel =
          AmountDistributionModel.fromJson(val);
      if (amountDistributionModel.code == GlobalData.UNAUTHORIZED_TOKEN) {
        //token失效
        AlertDialogWidget(title: '登陆过期,请重新登陆!').show(context).then((val) {
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => route == null);
        });
      } else if (amountDistributionModel.status == GlobalData.REQUEST_SUCCESS) {
        //数据返回正常
        myMoneyCalculate(amountDistributionModel);
        myDeliverCalculate(amountDistributionModel);
      } else {
        showToast('网络开小车了，请稍后再试。');
      }
    });
  }

  //我的快递单量计算
  void myDeliverCalculate(AmountDistributionModel amountDistributionModel) {
    double deliverInterval = amountDistributionModel.data.numBlock; //快递量区间范围
    print('快递量区间范围:${deliverInterval}');
    String deliverUnitLength = deliverInterval.ceil().toString(); //int类型的整数
    deliverUnit = getStringLengthUnit(deliverUnitLength); //单位
    int deliverUnitSize = pow(10, (deliverUnitLength.length - 1)); //10后面多少个0
    Map<String, dynamic> deliverMap = amountDistributionModel.data.numMap;

    //抽取数据并排序
    deliverMap.forEach((String key, value) {
      String endIndex =
          '${(double.parse(key).ceil() / deliverUnitSize).ceil()}';
      print('数值大小:${double.parse(key)} endIndex : ${endIndex}');
      if (deliverInterval == double.parse(key)) {
        //第一层
        deliverOrderList.removeAt(4);
        deliverOrderList.insert(4, OrdinalSales('0-${endIndex}', value));
      } else if ((deliverInterval * 2) == double.parse(key)) {
        //第二层
        deliverOrderList.removeAt(3);
        String startIndex =
            '${(deliverInterval.ceil() / deliverUnitSize).ceil()}';
        deliverOrderList.insert(
            3, OrdinalSales('${startIndex}-${endIndex}', value));
      } else if ((deliverInterval * 3) == double.parse(key)) {
        //第三层
        deliverOrderList.removeAt(2);
        String startIndex =
            '${((deliverInterval * 2).ceil() / deliverUnitSize).ceil()}';
        deliverOrderList.insert(
            2, OrdinalSales('${startIndex}-${endIndex}', value));
      } else if ((deliverInterval * 4) == double.parse(key)) {
        //第四层
        deliverOrderList.removeAt(1);
        String startIndex =
            '${((deliverInterval * 3).ceil() / deliverUnitSize).ceil()}';
        deliverOrderList.insert(
            1, OrdinalSales('${startIndex}-${endIndex}', value));
      } else if ((deliverInterval * 5) == double.parse(key)) {
        //第五层
        deliverOrderList.removeAt(0);
        String startIndex =
            '${((deliverInterval * 4).ceil() / deliverUnitSize).ceil()}';
        deliverOrderList.insert(
            0, OrdinalSales('${startIndex}-${endIndex}', value));
      }
    });

    setState(() {
      deliverOrderList;
      deliverUnit;
    });
  }

  //我的金额计算
  void myMoneyCalculate(AmountDistributionModel amountDistributionModel) {
    double moneyInterval = amountDistributionModel.data.moneyBlock; //金额间隔
    print('金额间隔:${moneyInterval}');
    String unitLength = moneyInterval.ceil().toString(); //int类型的整数
    moneyUnit = getStringLengthUnit(unitLength); //单位
    int unitSize = pow(10, (unitLength.length - 1)); //10后面几个0

    Map<String, dynamic> moneyMap = amountDistributionModel.data.moneyMap;
    moneyMap.forEach((String key, value) {
      String endIndex = '${(double.parse(key).ceil() / unitSize).ceil()}';
      print('数值大小:${double.parse(key)} endIndex : ${endIndex}');

      if (moneyInterval == double.parse(key)) {
        //第一层
        paidMoneyList.removeAt(4);
        paidMoneyList.insert(4, OrdinalSales('0-${endIndex}', value));
      } else if ((moneyInterval * 2) == double.parse(key)) {
        //第二层
        paidMoneyList.removeAt(3);
        String startIndex = '${(moneyInterval.ceil() / unitSize).ceil()}';
        print('startIndex = ${startIndex}');
        paidMoneyList.insert(
            3, OrdinalSales('${startIndex}-${endIndex}', value));
      } else if ((moneyInterval * 3) == double.parse(key)) {
        //第三层
        paidMoneyList.removeAt(2);
        String startIndex = '${((moneyInterval * 2).ceil() / unitSize).ceil()}';
        print('startIndex = ${startIndex}');
        paidMoneyList.insert(
            2, OrdinalSales('${startIndex}-${endIndex}', value));
      } else if ((moneyInterval * 4) == double.parse(key)) {
        //第四层
        paidMoneyList.removeAt(1);
        String startIndex = '${((moneyInterval * 3).ceil() / unitSize).ceil()}';
        print('startIndex = ${startIndex}');
        paidMoneyList.insert(
            1, OrdinalSales('${startIndex}-${endIndex}', value));
      } else if ((moneyInterval * 5) == double.parse(key)) {
        //第五层
        paidMoneyList.removeAt(0);
        String startIndex = '${((moneyInterval * 4).ceil() / unitSize).ceil()}';
        print('startIndex = ${startIndex}');
        paidMoneyList.insert(
            0, OrdinalSales('${startIndex}-${endIndex}', value));
      }
    });

//        for (int i = 0; i < paidMoneyList.length; i++) {
//          print('排完序的数组为:${paidMoneyList[i].year},${paidMoneyList[i].sales}');
//        }

    setState(() {
      myDeliverNum = amountDistributionModel.data.query.num; //快递单量
      myRealMoney = amountDistributionModel.data.query.realprice; //我的实收金额
      paidMoneyList;
      moneyUnit = moneyUnit.compareTo('个') == 0 ? '' : moneyUnit;
    });
  }

  //获取中文单位
  String getStringLengthUnit(String unitLength) {
    String unit = '';
    if (unitLength.length == 1) {
      unit = '个';
    } else if (unitLength.length == 2) {
      unit = '十';
    } else if (unitLength.length == 3) {
      unit = '百';
    } else if (unitLength.length == 4) {
      unit = '千';
    } else if (unitLength.length == 5) {
      unit = '万';
    } else if (unitLength.length == 6) {
      unit = '十万';
    } else if (unitLength.length == 7) {
      unit = '百万';
    } else if (unitLength.length == 8) {
      unit = '千万';
    }
    return unit;
  }

  @override
  Widget build(BuildContext context) {
    return LoadingContainer(
      cover: true,
      isLoading: _isLoading,
      marginTop: 400,
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _titleWidget(),
            SingleSelectRectangleWidget(
              listContent: ['鲜花', '洗涤'],
              stringBlock: (selectContent) {
                print('第一选项用户选择的为:${selectContent}');
                if (selectContent.compareTo('鲜花') == 0) {
                  _getAmountData('1', flag, area);
                  setState(() {
                    type = '1';
                  });
                } else if (selectContent.compareTo('洗涤') == 0) {
                  _getAmountData('2', flag, area);
                  setState(() {
                    type = '2';
                  });
                }
              },
            ),
            SingleSelectIndicatorWidget(
              listContent: ['昨日', '上周', '上月', '上季度'],
              stringBlock: (selectContent) {
                print('第二选项用户选择的为:${selectContent}');
                if (selectContent.compareTo('昨日') == 0) {
                  _getAmountData(type, '1', area);
                  setState(() {
                    flag = '1';
                  });
                } else if (selectContent.compareTo('上周') == 0) {
                  _getAmountData(type, '2', area);
                  setState(() {
                    flag = '2';
                  });
                } else if (selectContent.compareTo('上月') == 0) {
                  _getAmountData(type, '3', area);
                  setState(() {
                    flag = '3';
                  });
                } else if (selectContent.compareTo('上季度') == 0) {
                  _getAmountData(type, '4', area);
                  setState(() {
                    flag = '4';
                  });
                }
              },
            ),
            _citySelectWidget(),
            _expressCharWidget(),
            _spaceWidget(),
            _dollarChartWidget(),
          ],
        ),
      ),
    );
  }

  //空间布件
  Widget _spaceWidget() {
    return Container(
      height: AutoLayout.instance.pxToDp(24),
      color: ColorConstant.greyBgColor,
    );
  }

  //快递单量图表
  Widget _expressCharWidget() {
    return Container(
      height: AutoLayout.instance.pxToDp(450),
      margin: EdgeInsets.only(
          top: AutoLayout.instance.pxToDp(10),
          left: ScreenUtil().setWidth(10),
          right: ScreenUtil().setWidth(10),
          bottom: AutoLayout.instance.pxToDp(44)),
      width: ScreenUtil().setWidth(750),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //快递标题栏
          _commentTitleWidget('快递单量', '(我的单量${myDeliverNum}个)'),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              '(单量:${deliverUnit})',
              style: TextStyle(
                  color: ColorConstant.greyTextColor,
                  fontSize: ScreenUtil().setSp(26)),
            ),
          ),
          Expanded(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                  child: Container(
                child:
                    ExpressHorizontalBarChart.withSampleData(deliverOrderList),
              )),
              Text(
                '(人数)',
                style: TextStyle(
                    color: ColorConstant.greyTextColor,
                    fontSize: ScreenUtil().setSp(26)),
              )
            ],
          ))
        ],
      ),
    );
  }

  //通用标题栏
  Widget _commentTitleWidget(String title, String desc) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
              color: ColorConstant.blackTextColor,
              fontSize: ScreenUtil().setSp(28),
              fontWeight: FontWeight.w500),
        ),
        Text(
          desc,
          style: TextStyle(
              color: ColorConstant.greyTextColor,
              fontSize: ScreenUtil().setSp(24)),
        ),
      ],
    );
  }

  //营业额图表
  Widget _dollarChartWidget() {
    return Container(
      height: AutoLayout.instance.pxToDp(400),
      margin: EdgeInsets.only(
          top: AutoLayout.instance.pxToDp(10),
          left: ScreenUtil().setWidth(10),
          right: ScreenUtil().setWidth(10),
          bottom: AutoLayout.instance.pxToDp(44)),
      width: ScreenUtil().setWidth(750),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _commentTitleWidget('实收金额', '(我的实收金额¥${myRealMoney}元)'),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              '(金额:${moneyUnit}元)',
              style: TextStyle(
                  color: ColorConstant.greyTextColor,
                  fontSize: ScreenUtil().setSp(26)),
            ),
          ),
          Expanded(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                  child:
                      DollarHorizontalBarChart.withSampleData(paidMoneyList)),
              Text(
                '(人数)',
                style: TextStyle(
                    color: ColorConstant.greyTextColor,
                    fontSize: ScreenUtil().setSp(26)),
              )
            ],
          ))
        ],
      ),
    );
  }

  String _userSelect = '门店排行分布';
  List<String> _cityOptions = ['门店排行分布', '城市排名分布', '公司排名分布'];

  //排名方法选择
  Widget _citySelectWidget() {
    return Container(
      child: SinglePopMenuWidget(
        head: _userSelect,
        options: _cityOptions,
        onSelected: (String value) {
          if (value.compareTo('门店排行分布') == 0) {
            setState(() {
              _userSelect = value;
              area = '1';
            });
            _getAmountData(type, flag, area);
          } else if (value.compareTo('城市排名分布') == 0) {
            setState(() {
              _userSelect = value;
              area = '2';
            });
            _getAmountData(type, flag, area);
          } else if (value.compareTo('公司排名分布') == 0) {
            setState(() {
              _userSelect = value;
              area = '3';
            });
            _getAmountData(type, flag, area);
          }
        },
      ),
    );
  }

  //标题
  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(2)),
      height: AutoLayout.instance.pxToDp(83),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(color: ColorConstant.greyLineColor))),
      child: Row(
        children: [
          Container(
            child: Image.asset(
              'images/rectangle_indicator.png',
              width: ScreenUtil().setWidth(10),
              height: AutoLayout.instance.pxToDp(32),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(17)),
            child: Text(
              '单量和实收金额分布',
              style: TextStyle(
                  color: ColorConstant.blackTextColor,
                  fontSize: ScreenUtil().setSp(30)),
            ),
          )
        ],
      ),
    );
  }
}
