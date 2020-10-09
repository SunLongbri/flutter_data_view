import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/login/login_page.dart';
import 'package:fluttermarketingplus/model/myConsumer_model.dart';
import 'package:fluttermarketingplus/model/my_customer_model.dart';
import 'package:fluttermarketingplus/navigator/order_page/custom_management_page/messge_search_dialog_widget.dart';
import 'package:fluttermarketingplus/provider/data_provider.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/widgets/alert_dialog_widget.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';
import 'package:fluttermarketingplus/widgets/loading_container.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'my_consumer_details_page.dart';

//我的客户页面
class MyConsumerPage extends StatefulWidget {
  final String titleData;

  const MyConsumerPage({Key key, this.titleData}) : super(key: key);

  @override
  _MyConsumerPageState createState() => _MyConsumerPageState();
}

class _MyConsumerPageState extends State<MyConsumerPage> {
  int _indexPage; //页面
  List<DataList> _customerDataList = []; //数据列表
  int _totalConsumer;
  bool _isLoading;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Widget buildCtn() {
    return ListView.separated(
      itemBuilder: (c, i) => _singleCustomLineWidget(_customerDataList[i]),
      separatorBuilder: (context, index) {
        return Container(
          height: 0.5,
          color: ColorConstant.greyLineColor,
        );
      },
      itemCount: _customerDataList.length,
    );
  }

  Map<String, String> params;

  @override
  void initState() {
    _isLoading = false;
    _indexPage = 1;
    params = {"pageindex": _indexPage.toString(), "pagesize": "20"};
    _refreshCustomerData(params);
    super.initState();
  }

  //刷新我的客户数据列表
  void _refreshCustomerData(Map<String, String> params) {
    setState(() {
      _isLoading = true;
    });
    getRequest(API.MY_CUSTOMER, queryParameters: params).then((val) {
      setState(() {
        _isLoading = false;
      });
      print('我的客户:${val}');
      _refreshController.refreshCompleted();
      MyCustomerModel myCustomerModel = MyCustomerModel.fromJson(val);
      if (myCustomerModel.code == GlobalData.UNAUTHORIZED_TOKEN) {
        //token失效
        AlertDialogWidget(title: '登陆过期,请重新登陆!').show(context).then((val) {
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => route == null);
        });
      } else if (myCustomerModel.status == GlobalData.REQUEST_SUCCESS) {
        setState(() {
          _customerDataList.addAll(myCustomerModel.data.list);
          _totalConsumer = int.parse(myCustomerModel.data.total);
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
        title: '我的客户',
      ),
      body: LoadingContainer(
        cover: true,
        isLoading: _isLoading,
        child: Container(
          color: ColorConstant.greyBgColor,
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    MessageSearchDialog(
                      voidStringCallback: (val) {
                        _customerDataList.clear();
                        params = {
                          "pageindex": _indexPage.toString(),
                          "pagesize": "20"
                        };
                        List<String> search = val.split('_');
                        String type = search[0];
                        String content = search[1];
                        if (type.compareTo('姓名') == 0) {
                          params['user_name'] = content;
                        } else if (type.compareTo('电话') == 0) {
                          params['tel'] = content;
                        } else if (type.compareTo('地址') == 0) {
                          params['address'] = content;
                        }
                        _refreshCustomerData(params);
                      },
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Text("姓名",
                                style: TextStyle(
                                  color: ColorConstant.blackTextColor,
                                  fontSize: ScreenUtil().setSp(30),
                                ),
                                textAlign: TextAlign.center)),
                        Expanded(
                            child: Text("性别",
                                style: TextStyle(
                                  color: ColorConstant.blackTextColor,
                                  fontSize: ScreenUtil().setSp(30),
                                ),
                                textAlign: TextAlign.center)),
                        Expanded(
                            flex: 2,
                            child: Text("电话",
                                style: TextStyle(
                                  color: ColorConstant.blackTextColor,
                                  fontSize: ScreenUtil().setSp(30),
                                ),
                                textAlign: TextAlign.center)),
                        Expanded(
                            flex: 3,
                            child: Text("地址",
                                style: TextStyle(
                                  color: ColorConstant.blackTextColor,
                                  fontSize: ScreenUtil().setSp(30),
                                ),
                                textAlign: TextAlign.center)),
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _customerDataList.length != 0
                    ? SmartRefresher(
                        controller: _refreshController,
                        enablePullUp: true,
                        enablePullDown: true,
                        child: buildCtn(),
                        footer: ClassicFooter(
                          loadStyle: LoadStyle.ShowWhenLoading,
                          completeDuration: Duration(milliseconds: 500),
                        ),
                        header: WaterDropHeader(),
                        onRefresh: () {
                          setState(() {
                            _customerDataList.clear();
                            _refreshController.loadComplete();
                            _indexPage = 1;
                          });
                          _refreshCustomerData(params);
                        },
                        onLoading: () async {
                          print(
                              '_totalConsumer:${_totalConsumer},_indexPage:${_indexPage}');
                          if (_totalConsumer <= (_indexPage * 20)) {
                            _refreshController.loadNoData();
                          } else {
                            _indexPage++;
                            params['pageindex'] = _indexPage.toString();
                            _refreshCustomerData(params);
                            _refreshController.loadComplete();
                          }
                        },
                      )
                    : _isLoading ? Container() : _noDataWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

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

  Widget _singleCustomLineWidget(DataList customerDetails) {
    return GestureDetector(
        child: Container(
          color: Colors.white,
          height: ScreenUtil().setHeight(80),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Text(customerDetails.userName,
                      style: TextStyle(
                        color: ColorConstant.greyTextColor,
                        fontSize: ScreenUtil().setSp(26),
                      ),
                      textAlign: TextAlign.center)),
              Expanded(
                  child: Text(
                      customerDetails.sex.toString().compareTo('1') == 0
                          ? '男'
                          : '女',
                      style: TextStyle(
                        color: ColorConstant.greyTextColor,
                        fontSize: ScreenUtil().setSp(26),
                      ),
                      textAlign: TextAlign.center)),
              Expanded(
                  flex: 2,
                  child: Text(customerDetails.tel,
                      style: TextStyle(
                        color: ColorConstant.greyTextColor,
                        fontSize: ScreenUtil().setSp(26),
                      ),
                      textAlign: TextAlign.center)),
              Expanded(
                  flex: 3,
                  child: Text(customerDetails.address,
//                      maxLines: 1,
                      style: TextStyle(
                        color: ColorConstant.greyTextColor,
                        fontSize: ScreenUtil().setSp(26),
                      ),
                      textAlign: TextAlign.center)),
            ],
          ),
        ),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => MyConsumeDetailsPage(customerDetails)))
              .then((val) {
            setState(() {
              _customerDataList.clear();
              _refreshController.loadComplete();
              _indexPage = 1;
            });
            _refreshCustomerData(params);
          });
        });
  }
}
