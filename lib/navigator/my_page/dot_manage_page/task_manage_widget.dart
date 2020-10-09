import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/login/login_page.dart';
import 'package:fluttermarketingplus/model/store_delivers_task_model.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/alert_dialog_widget.dart';
import 'package:fluttermarketingplus/widgets/item_title_widget.dart';
import 'package:fluttermarketingplus/widgets/loading_container.dart';
import 'package:fluttermarketingplus/widgets/single_select_indicator_widget.dart';
import 'package:fluttermarketingplus/widgets/single_select_rectangle_widget.dart';
import 'package:oktoast/oktoast.dart';

//任务管理
class TaskManageWidget extends StatefulWidget {
  @override
  _TaskManageWidgetState createState() => _TaskManageWidgetState();
}

class _TaskManageWidgetState extends State<TaskManageWidget> {
  //门店下所有小哥的数据列表
  List<Data> deliversList;
  String type; //鲜花还是洗涤
  String flag; //下周等字段
  bool _isLoading; //是否加载数据
  bool _loadData;

  @override
  void initState() {
    _loadData = true;
    deliversList = [];
    type = '1';
    flag = '1';
    _isLoading = false;
    _initTabData(type, flag);
    super.initState();
  }

  _initTabData(String type, String flag) {
    Map<String, String> params = {"type": type, 'flag': flag, "user_id": '461'};
    setState(() {
      _isLoading = true;
    });
    getRequest(API.STORE_DELIVERS_TASK, queryParameters: params).then((val) {
      print('val:${val}');
      if (!_loadData) {
        return;
      }
      setState(() {
        _isLoading = false;
      });
      StoreDeliversTaskModel storeDeliversTaskModel =
          StoreDeliversTaskModel.fromJson(val);
      if (storeDeliversTaskModel.code == GlobalData.UNAUTHORIZED_TOKEN) {
        //token失效
        AlertDialogWidget(title: '登陆过期,请重新登陆!').show(context).then((val) {
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => route == null);
        });
      } else if (storeDeliversTaskModel.status == GlobalData.REQUEST_SUCCESS) {
        //数据返回成功
        setState(() {
          deliversList = storeDeliversTaskModel.data;
        });
      } else {
        //数据返回失败
        showToast('网络开小车了，请稍后再试!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingContainer(
      marginTop: 350,
      cover: true,
      isLoading: _isLoading,
      child: Container(
        color: Colors.white,
        height: AutoLayout.instance.pxToDp(620),
        child: Column(
          children: [
            ItemTitleWidget('任务'),
            _menuSelectWidget(),
            _titleMenuWidget(),
            Expanded(
                child: ListView.builder(
                    itemCount: deliversList.length,
                    itemBuilder: (BuildContext context, int position) {
                      return _singleRowDataWidget(
                          deliversList[position].userName,
                          '${deliversList[position].flowerCount.isEmpty ? '0' : deliversList[position].flowerCount}单',
                          '¥${deliversList[position].flowerMoney.isEmpty ? '0' : deliversList[position].flowerMoney}');
                    }))
          ],
        ),
      ),
    );
  }

  //单行数据组件
  Widget _singleRowDataWidget(String name, String orderCount, String money) {
    return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: ColorConstant.greyLineColor))),
      child: Row(
        children: [
          _singleDataWidget(name, 1),
          _singleDataWidget(orderCount, 1),
          _singleDataWidget(money, 1),
        ],
      ),
    );
  }

  //标题栏的选择组件
  Widget _menuSelectWidget() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SingleSelectRectangleWidget(
            listContent: ['鲜花', '洗涤'],
            stringBlock: (firstSelect) {
              if (firstSelect.compareTo('鲜花') == 0) {
                setState(() {
                  type = '1';
                });
                _initTabData(type, flag);
              } else if (firstSelect.compareTo('洗涤') == 0) {
                setState(() {
                  type = '2';
                });
                _initTabData(type, flag);
              }
            },
          ),
          SingleSelectIndicatorWidget(
            paddingBottom: 1,
            listContent: ['下周', '下个月', '下一季度', '明年'],
            stringBlock: (secondSelect) {
              if (secondSelect.compareTo('下周') == 0) {
                setState(() {
                  flag = '1';
                });
                _initTabData(type, flag);
              } else if (secondSelect.compareTo('下个月') == 0) {
                setState(() {
                  flag = '2';
                });
                _initTabData(type, flag);
              } else if (secondSelect.compareTo('下一季度') == 0) {
                setState(() {
                  flag = '3';
                });
                _initTabData(type, flag);
              } else if (secondSelect.compareTo('明年') == 0) {
                setState(() {
                  flag = '4';
                });
                _initTabData(type, flag);
              }
            },
          ),
        ],
      ),
    );
  }

  //任务菜单下标题栏组件
  Widget _titleMenuWidget() {
    return Container(
      height: AutoLayout.instance.pxToDp(74),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: ColorConstant.greyLineColor))),
      child: Row(
        children: [
          _singleDataWidget('小哥/网点', 1,
              contentColor: ColorConstant.blackTextColor),
          _singleDataWidget('单量', 1,
              contentColor: ColorConstant.blackTextColor),
          _singleDataWidget('实收金额', 1,
              contentColor: ColorConstant.blackTextColor),
        ],
      ),
    );
  }

  //单个数据组件
  Widget _singleDataWidget(String content, int flex,
      {Color contentColor = ColorConstant.greyTextColor}) {
    return Expanded(
        flex: flex,
        child: Container(
          height: AutoLayout.instance.pxToDp(78),
          color: Colors.white,
          padding: EdgeInsets.only(
              top: AutoLayout.instance.pxToDp(10),
              bottom: AutoLayout.instance.pxToDp(10)),
          alignment: Alignment.center,
          child: Text(
            content,
            style: TextStyle(
                color: contentColor,
                fontSize: contentColor == ColorConstant.greyTextColor
                    ? ScreenUtil().setSp(26)
                    : ScreenUtil().setSp(30)),
          ),
        ));
  }

  @override
  void dispose() {
    _loadData = false;
    super.dispose();
  }
}
