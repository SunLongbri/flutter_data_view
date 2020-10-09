import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/login/login_page.dart';
import 'package:fluttermarketingplus/model/my_task_rate_model.dart';
import 'package:fluttermarketingplus/provider/data_provider.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/alert_dialog_widget.dart';
import 'package:fluttermarketingplus/widgets/loading_container.dart';
import 'package:fluttermarketingplus/widgets/single_select_indicator_widget.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'my_task_rate_widget.dart';

//完成率
class CompleteRateWidget extends StatefulWidget {
  @override
  _CompleteRateWidgetState createState() => _CompleteRateWidgetState();
}

class _CompleteRateWidgetState extends State<CompleteRateWidget> {
  //用户选择表盘所显示的类型
  String _selectType = '鲜花数量';
  String type = '1';
  String flag = '1';
  DataProvider dataProvider;
  bool _isLoading;

  @override
  void initState() {
    _isLoading = false;
    _getTaskRate(type, flag);
    super.initState();
  }

  //flag：哪个月份，type：哪种种类
  _getTaskRate(String type, String flag) {
    Map<String, String> params = {'flag': flag, 'type': type};
    setState(() {
      _isLoading = true;
    });
    getRequest(API.MY_TASK_RATE, queryParameters: params).then((val) {
      setState(() {
        _isLoading = false;
      });
      print('val:${val}');
      MyTaskRateModel myTaskRateModel = MyTaskRateModel.fromJson(val);
      if (myTaskRateModel.code == GlobalData.UNAUTHORIZED_TOKEN) {
        //token失效
        AlertDialogWidget(title: '登陆过期,请重新登陆!').show(context).then((val) {
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => route == null);
        });
      } else if (myTaskRateModel.status == GlobalData.REQUEST_SUCCESS) {
        //数据返回成功
        dataProvider.taskRate = double.parse(myTaskRateModel.data.ratio);
      } else {
        showToast('网络开小车了，请稍后再试!');
      }
    });
  }

  List<String> flagList = ['上周', '上月', '上季度', '去年'];

  @override
  Widget build(BuildContext context) {
    dataProvider = Provider.of<DataProvider>(context);
    return LoadingContainer(
      cover: true,
      isLoading: _isLoading,
      marginTop: 300,
      child: Container(
//        padding: EdgeInsets.only(bottom: 80),
        color: Colors.white,
        child: Column(
          children: [
            _titleWidget(),
            SingleSelectIndicatorWidget(
              paddingTop: 20,
              listContent: flagList,
              stringBlock: (selectContent) {
                if (selectContent.compareTo(flagList[0]) == 0) {
                  flag = '1';
                } else if (selectContent.compareTo(flagList[1]) == 0) {
                  flag = '2';
                } else if (selectContent.compareTo(flagList[2]) == 0) {
                  flag = '3';
                } else if (selectContent.compareTo(flagList[3]) == 0) {
                  flag = '4';
                }
                _getTaskRate(type, flag);
              },
            ),
            Column(
              children: [
                MYTaskRateWidget(),
                Container(
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(10),
                      right: ScreenUtil().setWidth(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _singleRadio('鲜花数量'),
                      _singleRadio('鲜花实收'),
                      _singleRadio('洗涤单量'),
                      _singleRadio('洗涤实收'),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  //单行选择框
  Widget _singleRadio(String content) {
    return Container(
      child: Row(
        children: [
          Container(
            width: ScreenUtil().setWidth(40),
            child: Radio(
              value: content,
              groupValue: _selectType,
              onChanged: (value) {
                setState(() {
                  _selectType = value;
                  print('选中的type为:${_selectType}');
                  if (_selectType.compareTo('鲜花数量') == 0) {
                    type = '1';
                  } else if (_selectType.compareTo('鲜花实收') == 0) {
                    type = '2';
                  } else if (_selectType.compareTo('洗涤单量') == 0) {
                    type = '3';
                  } else if (_selectType.compareTo('洗涤实收') == 0) {
                    type = '4';
                  }
                  _getTaskRate(type, flag);
                });
              },
            ),
          ),
          Text(content),
        ],
      ),
    );
  }

  Widget _titleWidget() {
    return Container(
      height: AutoLayout.instance.pxToDp(80),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(color: ColorConstant.greyLineColor))),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(17)),
            width: ScreenUtil().setWidth(10),
            height: AutoLayout.instance.pxToDp(32),
            color: ColorConstant.blueTextColor,
          ),
          Text(
            '达成率',
            style: TextStyle(
                color: ColorConstant.blackTextColor,
                fontSize: ScreenUtil().setSp(30)),
          )
        ],
      ),
    );
  }
}
