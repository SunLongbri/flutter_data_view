import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/login/login_page.dart';
import 'package:fluttermarketingplus/model/dot_manage_deliver_model.dart';
import 'package:fluttermarketingplus/model/dot_manage_search_model.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/alert_dialog_widget.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';
import 'package:fluttermarketingplus/widgets/bottom_cupertion_widget.dart';
import 'package:fluttermarketingplus/widgets/loading_container.dart';
import 'package:oktoast/oktoast.dart';

import 'custom_management_page/messge_search_dialog_widget.dart';

//客户管理页面
class CustomerManagementPage extends StatefulWidget {
  @override
  _CustomerManagementPageState createState() => _CustomerManagementPageState();
}

class _CustomerManagementPageState extends State<CustomerManagementPage> {
  List<String> _deliversList; //店长下所有小哥姓名
  String _searchName; //根据名字进行搜索
  List<SearchData> listSearchData; //搜索返回结果
  bool _isLoading; //是否加载数据

  @override
  void initState() {
    _isLoading = false;
    listSearchData = [];
    _deliversList = ['全部'];
    _searchName = '';
    getRequest(API.DOT_MANAGE_DELIVER).then((val) {
      print('val:${val}');
      DotManageDeliverModel dotManageDeliverModel =
          DotManageDeliverModel.fromJson(val);
      if (dotManageDeliverModel.code == GlobalData.UNAUTHORIZED_TOKEN) {
        //token失效
        AlertDialogWidget(title: '登陆过期,请重新登陆!').show(context).then((val) {
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => route == null);
        });
      } else if (dotManageDeliverModel.status == GlobalData.REQUEST_SUCCESS) {
        List<Data> deliverData = dotManageDeliverModel.data;
        setState(() {
          for (int i = 0; i < deliverData.length; i++) {
            _deliversList.add(deliverData[i].nickname);
          }
        });
      } else {
        showToast('网络开小车了,请稍后再试!');
      }
    });
    Map<String, String> param = {"nickname": _searchName};
    _initSearchData(param, 0);
    super.initState();
  }

  _initSearchData(Map<String, String> param, int type) {
    listSearchData.clear();
    setState(() {
      _isLoading = true;
    });
    String url;
    if (type == 0) {
      url = API.DOT_MANAGE_SEARCH;
    } else if (type == 1) {
      url = API.DOT_MANAGE_TYPE_SEARCH;
    }

    getRequest(url, queryParameters: param).then((val) {
      print('门店客户接受到的数据为:${val}');
      setState(() {
        _isLoading = false;
      });
      DotManageSearchModel dotManageSearchModel =
          DotManageSearchModel.fromJson(val);
      if (dotManageSearchModel.code == GlobalData.UNAUTHORIZED_TOKEN) {
        //token失效
        AlertDialogWidget(title: '登陆过期,请重新登陆!').show(context).then((val) {
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => route == null);
        });
      } else if (dotManageSearchModel.status == GlobalData.REQUEST_SUCCESS) {
        setState(() {
          listSearchData = dotManageSearchModel.data;
        });
      } else {
        showToast('网络开小车了,请稍后再试!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '门店客户',
        actionsWidget: _actionWidget(),
      ),
      body: LoadingContainer(
        cover: true,
        isLoading: _isLoading,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              MessageSearchDialog(
                voidStringCallback: (val) {
                  List<String> search = val.split('_');
                  String type = search[0];
                  String content = search[1];
                  if (type.compareTo('姓名') == 0) {
                    type = '1';
                  } else if (type.compareTo('电话') == 0) {
                    type = '2';
                  } else if (type.compareTo('地址') == 0) {
                    type = '3';
                  }
                  Map<String, String> param = {'type': type, 'param': content};
                  _initSearchData(param, 1);
                },
              ),
              _dataListWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionWidget() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        print('_deliversList:${_deliversList.length}');
        if (_deliversList.isEmpty) {
          showToast('暂无数据');
          return;
        }
        BottomCupertionWidget(listContent: _deliversList)
            .selectData(context)
            .then((val) {
          print('用户选择的为:${val}');
          setState(() {
            _searchName = val;
            if (val.compareTo('全部') == 0) {
              setState(() {
                _searchName = '';
              });
            }
          });
          Map<String, String> param = {"nickname": _searchName};
          _initSearchData(param, 0);
        });
      },
      child: Container(
        width: ScreenUtil().setWidth(44),
        child: Image.asset(
          'images/manager_screen.png',
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  //数据列表组件
  Widget _dataListWidget() {
    return Expanded(
      child: Column(
        children: [
          _titleWidget('姓名', '性别', '电话', '地址'),
          Container(
            height: AutoLayout.instance.pxToDp(24),
            color: ColorConstant.greyBgColor,
          ),
          Expanded(
              child: listSearchData.length != 0
                  ? Container(
                      child: ListView.builder(
                          itemCount: listSearchData.length,
                          itemBuilder: (BuildContext context, int position) {
                            return _singleRowDataWidget(
                                listSearchData[position].userName,
                                listSearchData[position].sex.contains('1')
                                    ? '男'
                                    : '女',
                                listSearchData[position].tel,
                                listSearchData[position].address);
                          }),
                    )
                  : _isLoading ? Container() : _noDataWidget())
        ],
      ),
    );
  }

  //没有数据展示
  Widget _noDataWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: Image.asset(
            'images/no_data.png',
            width: ScreenUtil().setWidth(374),
            fit: BoxFit.fitWidth,
          ),
        ),
        Text(
          '暂无数据',
          style: TextStyle(
              color: ColorConstant.greyTextColor,
              fontSize: ScreenUtil().setSp(25)),
        )
      ],
    );
  }

  //单行数据组件
  Widget _titleWidget(String name, String sex, String phone, String address) {
    return Container(
      child: Row(
        children: [
          _titleCellWidget(name, 1),
          _titleCellWidget(sex, 1),
          _titleCellWidget(phone, 2),
          _titleCellWidget(address, 3),
        ],
      ),
    );
  }

  //单行数据组件
  Widget _singleRowDataWidget(
      String name, String sex, String phone, String address) {
    return Container(
      child: Row(
        children: [
          _dataCellWidget(name, 1),
          _dataCellWidget(sex, 1),
          _dataCellWidget(phone, 2),
          _dataCellWidget(address, 3),
        ],
      ),
    );
  }

  //单个数据组件
  Widget _titleCellWidget(String content, int flex) {
    return Expanded(
        flex: flex,
        child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          height: AutoLayout.instance.pxToDp(108),
          child: Text(
            content,
            style: TextStyle(
                color: ColorConstant.blackTextColor,
                fontSize: ScreenUtil().setSp(30)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ));
  }

  Widget _dataCellWidget(String content, int flex) {
    return Expanded(
        flex: flex,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(color: ColorConstant.greyLineColor)),
          ),
          alignment: Alignment.center,
          height: AutoLayout.instance.pxToDp(108),
          child: Text(
            content,
            style: TextStyle(
                color: ColorConstant.greyTextColor,
                fontSize: ScreenUtil().setSp(26)),
            textAlign: TextAlign.center,
//            maxLines: 1,
//            overflow: TextOverflow.ellipsis,
          ),
        ));
  }
}
