import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/login/login_page.dart';
import 'package:fluttermarketingplus/model/customer_comment_model.dart';
import 'package:fluttermarketingplus/model/yestarday_war_info_model.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/alert_dialog_widget.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';
import 'package:fluttermarketingplus/widgets/loading_container.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


//我的评价
class OrderCommentPage extends StatefulWidget {
  final List<DataList> commentList;

  const OrderCommentPage({Key key, this.commentList}) : super(key: key);

  @override
  _OrderCommentPageState createState() => _OrderCommentPageState();
}

class _OrderCommentPageState extends State<OrderCommentPage> {
  //用户所有订单评价
  List<DataList> commentAllList = [];
  RefreshController _refreshController;
  Map<String, String> params;
  int _pageIndex;
  int _totalCount;
  List<SingleComment> commentDataList;
  bool _isLoading;

  @override
  void initState() {
    _isLoading = false;
    _pageIndex = 1;
    commentDataList = [];
    _refreshController = RefreshController(initialRefresh: false);
    commentAllList = widget.commentList;
    _refreshUserCommentData();
    super.initState();
  }

  _refreshUserCommentData() {
    params = {'pageindex': _pageIndex.toString(), 'pagesize': '10'};
    setState(() {
      _isLoading = true;
    });
    getRequest(API.EVALUATE_COMMENT, queryParameters: params).then((val) {
      setState(() {
        _isLoading = false;
      });
      CustomerCommentModel customerCommentModel =
          CustomerCommentModel.fromJson(val);
      if (customerCommentModel.code == GlobalData.UNAUTHORIZED_TOKEN) {
        //token失效
        AlertDialogWidget(title: '登陆过期,请重新登陆!').show(context).then((val) {
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => route == null);
        });
      } else if (customerCommentModel.status == GlobalData.REQUEST_SUCCESS) {
        setState(() {
          _totalCount = int.parse(customerCommentModel.data.total);
          commentDataList.addAll(customerCommentModel.data.list);
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
        title: '用户评价',
      ),
      body: LoadingContainer(
        cover: true,
        isLoading: _isLoading,
        child: SmartRefresher(
          controller: _refreshController,
          enablePullUp: true,
          enablePullDown: false,
          child: ListView.builder(
              itemCount: commentDataList.length,
              itemBuilder: (BuildContext context, int position) {
                return _singleCardWidget(
                    commentDataList[position].nickname.isEmpty
                        ? '***'
                        : commentDataList[position].nickname,
                    commentDataList[position].createDatetime,
                    commentDataList[position].info);
              }),
          footer: ClassicFooter(
            loadStyle: LoadStyle.ShowWhenLoading,
            completeDuration: Duration(milliseconds: 500),
          ),
          header: WaterDropHeader(),
          onLoading: () async {
            _pageIndex++;
            _refreshUserCommentData();
            if (_totalCount < (_pageIndex * 20)) {
              _refreshController.loadNoData();
            } else {
              _refreshController.loadComplete();
            }
          },
        ),
      ),
    );
  }

  //单张用户评价组件
  Widget _singleCardWidget(
      String userName, String publicTime, String userComment) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: AutoLayout.instance.pxToDp(24)),
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(27), right: ScreenUtil().setWidth(27)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _cardFirstFloorWidget(userName, publicTime),
          _cardSecondFloorWidget(userComment),
        ],
      ),
    );
  }

  Widget _cardSecondFloorWidget(String userComment) {
    return Container(
      margin: EdgeInsets.only(
          bottom: AutoLayout.instance.pxToDp(35),
          top: AutoLayout.instance.pxToDp(34)),
      alignment: Alignment.centerLeft,
      child: Text(
        userComment,
        style: TextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(25)),
      ),
    );
  }

  Widget _cardFirstFloorWidget(String userName, String publicTime) {
    return Container(
      margin: EdgeInsets.only(top: AutoLayout.instance.pxToDp(37)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(25)),
                width: ScreenUtil().setWidth(87),
                child: Image.asset(
                  'images/user_head.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
              Text(
                userName,
                style: TextStyle(
                    color: ColorConstant.blackTextColor,
                    fontSize: ScreenUtil().setSp(30)),
              )
            ],
          ),
          Container(
            child: Text(
              publicTime,
              style: TextStyle(
                  color: ColorConstant.greyTextColor,
                  fontSize: ScreenUtil().setSp(24)),
            ),
          )
        ],
      ),
    );
  }
}
