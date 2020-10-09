import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/login/login_page.dart';
import 'package:fluttermarketingplus/model/evaluate_top_model.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/alert_dialog_widget.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';
import 'package:fluttermarketingplus/widgets/loading_container.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

//好评率排名
class PraiseNumberPage extends StatefulWidget {
  @override
  _PraiseNumberPageState createState() => _PraiseNumberPageState();
}

class _PraiseNumberPageState extends State<PraiseNumberPage> {
  List<DataList> _dataList;

  //刷新控制器
  RefreshController _refreshController;

  //分页加载-页数
  int _pageIndex;

  //我的佣金数据总量
  int _totalCount;

  bool _isLoading;

  @override
  void initState() {
    _dataList = [];
    _pageIndex = 1;
    _isLoading = false;
    _refreshController = RefreshController(initialRefresh: false);
    _refreshPriseNumberData();
    super.initState();
  }

  _refreshPriseNumberData() {
    Map<String, String> params = {
      'pageindex': _pageIndex.toString(),
      "pagesize": '20'
    };
    setState(() {
      _isLoading = true;
    });
    getRequest(API.EVALUATE_TOP, queryParameters: params).then((val) {
      print('val:${val}');
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
      });
      EvaluateTopModel evaluateTopModel = EvaluateTopModel.fromJson(val);
      if (evaluateTopModel.code == GlobalData.UNAUTHORIZED_TOKEN) {
        //token失效
        AlertDialogWidget(title: '登陆过期,请重新登陆!').show(context).then((val) {
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => route == null);
        });
      } else if (evaluateTopModel.status == GlobalData.REQUEST_SUCCESS) {
        if (evaluateTopModel.data.list.isEmpty) {
          return;
        }
        setState(() {
          if (_pageIndex == 1) {
            _dataList.add(evaluateTopModel.data.user);
          }
          _dataList.addAll(evaluateTopModel.data.list);
          _totalCount = int.parse(evaluateTopModel.data.total);
        });
      } else {
        showToast('网络开小车了,请稍后再试!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBarWidget(
        title: '好评率排名',
      ),
      body: LoadingContainer(
        cover: true,
        isLoading: _isLoading,
        child: Container(
          child: Column(
            children: <Widget>[
              _titleWidget(),
              Expanded(
                child: SmartRefresher(
                  controller: _refreshController,
                  enablePullUp: true,
                  enablePullDown: false,
                  child: ListView.builder(
                      itemCount: _dataList.length,
                      itemBuilder: (BuildContext context, int position) {
                        return _singleLineWidget(
                            'images/head1.jpeg',
                            _dataList[position].nickname,
                            position,
                            _dataList[position].userId.toString(),
                            _dataList[position].ratio,
                            _dataList[position].num);
                      }),
                  footer: ClassicFooter(
                    loadStyle: LoadStyle.ShowWhenLoading,
                    completeDuration: Duration(milliseconds: 500),
                  ),
                  header: WaterDropHeader(),
                  onLoading: () async {
                    _pageIndex++;
                    _refreshPriseNumberData();
                    if (_totalCount < (_pageIndex * 20)) {
                      _refreshController.loadNoData();
                    } else {
                      _refreshController.loadComplete();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //单行数据组件
  Widget _singleLineWidget(String imageAssets, String name, int index,
      String workNumber, double rate, double ranking) {
    Color bgColor;
    if (index == 0) {
      bgColor = ColorConstant.blueTextColor;
    } else {
      bgColor = Colors.white;
    }
    return Container(
      height: AutoLayout.instance.pxToDp(81),
      color: bgColor,
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(250),
            child: _deliverWidget(name, index),
          ),
          Expanded(
            child: _lineTextWidget(workNumber, index),
            flex: 1,
          ),
          Expanded(
            child: _lineTextWidget('${rate * 100}%', index),
            flex: 2,
          ),
          Expanded(
            child:
            _lineTextWidget('第${ranking.toString().split('.')[0]}', index),
            flex: 1,
          ),
        ],
      ),
    );
  }

  //小哥组件
  Widget _deliverWidget(String name, int index) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
              width: ScreenUtil().setWidth(52),
              child: ClipOval(
                child: Image.asset(
                  'images/head1.jpeg',
                  fit: BoxFit.fitWidth,
                ),
              )),
          _lineTextWidget(name, index),
        ],
      ),
    );
  }

  //当行数据列表文字样式
  Widget _lineTextWidget(String content, int index) {
    Color textColor;
    if (index == 0) {
      textColor = Colors.white;
    } else {
      textColor = ColorConstant.greyTextColor;
    }
    return Container(
      alignment: Alignment.center,
      child: Text(
        content,
        style: TextStyle(color: textColor, fontSize: ScreenUtil().setSp(26)),
      ),
    );
  }

  //好评率排行-标题
  Widget _titleWidget() {
    return Container(
      color: Colors.white,
      child: Row(
        children: <Widget>[
          _singleCellWidget('小哥', 2, alignmentGeometry: Alignment.bottomCenter),
          _singleCellWidget('工号', 1, alignmentGeometry: Alignment.bottomCenter),
          _singleCellWidget('好评率', 2,
              alignmentGeometry: Alignment.bottomCenter),
          _singleCellWidget('名次', 1, alignmentGeometry: Alignment.bottomCenter),
        ],
      ),
    );
  }

  //单元格组件
  Widget _singleCellWidget(String content, int flex,
      {AlignmentGeometry alignmentGeometry = Alignment.center}) {
    return Expanded(
      flex: flex,
      child: _textWidget(content, alignmentGeometry: alignmentGeometry),
    );
  }

  Widget _textWidget(String content,
      {AlignmentGeometry alignmentGeometry = Alignment.center}) {
    double bottomHeight = 0;
    if (alignmentGeometry == Alignment.bottomCenter) {
      bottomHeight = 12;
    }
    return Container(
      padding:
      EdgeInsets.only(bottom: AutoLayout.instance.pxToDp(bottomHeight)),
      height: AutoLayout.instance.pxToDp(83),
      alignment: alignmentGeometry,
      decoration: BoxDecoration(
          border:
          Border(bottom: BorderSide(color: ColorConstant.greyLineColor))),
      child: Text(
        content,
        style: TextStyle(
            fontSize: ScreenUtil().setSp(30),
            color: ColorConstant.blackTextColor),
      ),
    );
  }
}
