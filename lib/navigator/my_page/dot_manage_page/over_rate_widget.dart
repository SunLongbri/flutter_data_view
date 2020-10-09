import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/login/login_page.dart';
import 'package:fluttermarketingplus/model/dot_rate_menu_model.dart';
import 'package:fluttermarketingplus/model/dot_rate_model.dart';
import 'package:fluttermarketingplus/navigator/my_page/show_report_page/completion_rate_widget/task_rate_widget.dart';
import 'package:fluttermarketingplus/provider/data_provider.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/alert_dialog_widget.dart';
import 'package:fluttermarketingplus/widgets/item_title_widget.dart';
import 'package:fluttermarketingplus/widgets/loading_container.dart';
import 'package:fluttermarketingplus/widgets/single_pop_menu_widget.dart';
import 'package:fluttermarketingplus/widgets/single_select_indicator_widget.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

//任务完成情况组件
class OverRateWidget extends StatefulWidget {
  @override
  _OverRateWidgetState createState() => _OverRateWidgetState();
}

class _OverRateWidgetState extends State<OverRateWidget> {
  //用户选择表盘所显示的类型
  String _selectType = '鲜花数量';
  String _userSelect;

  //底部弹出菜单选项列表
  List<MenuData> _listData;
  List<String> _cityOptions;
  bool _isLoading;

  //偏离值
  String _sub;

  //偏离百分比
  double _rate;

  //---达成率穿参---
  String _time; //昨天，上周，上月，上季度
  String _type; //鲜花数量，鲜花实收等
  String _store; //用户menu选择条目
  String _storeId; //menu条目下所对应的id

  DataProvider _dataProvider;

  //是否显示底部弹出菜单
  bool isShow;
  bool _loadData;

  @override
  void initState() {
    _loadData = true;
    _sub = '';
    _rate = 0;
    _time = '1';
    _type = '1';
    _isLoading = false;
    _userSelect = '暂无数据';
    _cityOptions = ['暂无数据'];
    isShow = false;
    _initMenuData();
    super.initState();
  }

  @override
  void dispose() {
    _loadData = false;
    super.dispose();
  }

  //初始化菜单数据
  void _initMenuData() {
    setState(() {
      _isLoading = true;
    });
    getRequest(API.DOT_RATE_MENU).then((val) {
      if (!_loadData) {
        return;
      }
      setState(() {
        _isLoading = false;
      });
      print('val:${val}');
      DotRateMenuModel dotRateMenuModel = DotRateMenuModel.fromJson(val);
      if (dotRateMenuModel.code == GlobalData.UNAUTHORIZED_TOKEN) {
        //token失效
        AlertDialogWidget(title: '登陆过期,请重新登陆!').show(context).then((val) {
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => route == null);
        });
      } else if (dotRateMenuModel.status == GlobalData.REQUEST_SUCCESS) {
        //数据返回成功
        _listData = dotRateMenuModel.data;
        if (_listData.isNotEmpty) {
          _cityOptions.clear();
        }
        setState(() {
          _userSelect = _listData[0].name;
          _store = _listData[0].type;
          _storeId = _listData[0].id;
          for (int i = 0; i < _listData.length; i++) {
            _cityOptions.add(_listData[i].name);
          }
          _userSelect = _cityOptions[0];
        });
        _refreshRateData(_time, _type, _store, _storeId);
      } else {
        //数据返回失败
        showToast('网络开小车了，请稍后再试！');
      }
    });
  }

  //刷新网点管理报表达成率
  void _refreshRateData(
      String time, String type, String store, String storeId) {
    Map<String, String> params = {
      'time': time,
      'type': type,
      'post': store,
      'postId': storeId
    };
    setState(() {
      _isLoading = true;
    });
    getRequest(API.DOT_RATE, queryParameters: params).then((val) {
      setState(() {
        _isLoading = false;
      });
      print('达成率请求到的数据为:${val}');
      DotRateModel dotRateModel = DotRateModel.fromJson(val);
      if (dotRateModel.status == GlobalData.REQUEST_SUCCESS) {
        //数据返回成功
        if (dotRateModel.data.isEmpty) {
          showToast('未查到数据');
          _dataProvider.dotRate = 0;
          setState(() {
            _sub = '';
          });
          return;
        }
        setState(() {
          String rate = dotRateModel.data[0].rate;
          if (rate.contains('%')) {
            rate = rate.split('%')[0];
          }
          _rate = double.parse(rate); //百分比
          _sub = dotRateModel.data[0].sub; //偏离单量
          _dataProvider.dotRate = _rate;
        });
      } else if (dotRateModel.status == GlobalData.UNAUTHORIZED_TOKEN) {
        //token失效
        AlertDialogWidget(title: '登陆过期,请重新登陆!').show(context).then((val) {
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => route == null);
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        _dataProvider.dotRate = 0;
        setState(() {
          _sub = '';
        });
        //数据返回失败
        showToast('网络开小车了,请稍后再试!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _dataProvider = Provider.of<DataProvider>(context);
    return LoadingContainer(
      marginTop: 300,
      cover: true,
      isLoading: _isLoading,
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(bottom: AutoLayout.instance.pxToDp(40)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _space(),
            ItemTitleWidget(
              '达成率',
              marginTop: 10,
            ),
            SingleSelectIndicatorWidget(
              paddingTop: 20,
              listContent: ['上周', '上月', '上季度', '去年'],
              stringBlock: (selectMenu) {
                print('用户选择的菜单为：${selectMenu}');
                if (selectMenu.compareTo('上周') == 0) {
                  setState(() {
                    _time = '1';
                  });
                  _refreshRateData(_time, _type, _store, _storeId);
                } else if (selectMenu.compareTo('上月') == 0) {
                  setState(() {
                    _time = '2';
                  });
                  _refreshRateData(_time, _type, _store, _storeId);
                } else if (selectMenu.compareTo('上季度') == 0) {
                  setState(() {
                    _time = '3';
                  });
                  _refreshRateData(_time, _type, _store, _storeId);
                } else if (selectMenu.compareTo('去年') == 0) {
                  setState(() {
                    _time = '4';
                  });
                  _refreshRateData(_time, _type, _store, _storeId);
                }
              },
            ),

            SinglePopMenuWidget(
              head: _userSelect,
              options: _cityOptions,
              onSelected: (String value) async {
                print('点击到的文字为:${value}');
                for (int i = 0; i < _cityOptions.length; i++) {
                  setState(() {
                    _userSelect = value;
                  });
                  String name;
                  for (int j = 0; j < _listData.length; j++) {
                    name = _listData[j].name;
                    if (_listData[j].name.compareTo(value) == 0) {
                      setState(() {
                        _store = _listData[j].type;
                        _storeId = _listData[j].id;
                      });
                      _refreshRateData(_time, _type, _store, _storeId);
                      break;
                    }
                  }
                  if (name.compareTo(value) == 0) {
                    break;
                  }
                }
              },
            ),
            //任务完成情况
            TaskRateWidget(
              rate: _rate,
              sub: _sub,
            ),
            _singleSelectRadioWidget(),
          ],
        ),
      ),
    );
  }

  //单个向下弹出菜单组件
  Widget _singleMenuItemWidget(String content) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        showToast('点击了${content}条目!');
        setState(() {
          isShow = false;
        });
      },
      child: Container(
        height: AutoLayout.instance.pxToDp(65),
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: ColorConstant.greyLineColor))),
        child: Text(
          content,
          style: TextStyle(
              color: ColorConstant.greyTextColor,
              fontSize: ScreenUtil().setSp(25)),
        ),
      ),
    );
  }

  Widget _space() {
    return Container(
      color: ColorConstant.greyBgColor,
      height: AutoLayout.instance.pxToDp(24),
    );
  }

  //单选按钮群组件
  Widget _singleSelectRadioWidget() {
    return Column(
      children: [
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
                });
                if (_selectType.compareTo('鲜花数量') == 0) {
                  setState(() {
                    _type = '1';
                  });
                  _refreshRateData(_time, _type, _store, _storeId);
                } else if (_selectType.compareTo('鲜花实收') == 0) {
                  setState(() {
                    _type = '2';
                  });
                  _refreshRateData(_time, _type, _store, _storeId);
                } else if (_selectType.compareTo('洗涤单量') == 0) {
                  setState(() {
                    _type = '3';
                  });
                  _refreshRateData(_time, _type, _store, _storeId);
                } else if (_selectType.compareTo('洗涤实收') == 0) {
                  setState(() {
                    _type = '4';
                  });
                  _refreshRateData(_time, _type, _store, _storeId);
                }
              },
            ),
          ),
          Text(content),
        ],
      ),
    );
  }
}
