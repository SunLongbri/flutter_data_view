import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/login/login_page.dart';
import 'package:fluttermarketingplus/model/yestarday_war_info_model.dart';
import 'package:fluttermarketingplus/routers/jump_receive.dart';
import 'package:fluttermarketingplus/routers/routes.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/alert_dialog_widget.dart';
import 'package:oktoast/oktoast.dart';

import 'order_comment_page.dart';

//昨日战况
class AchievementWidget extends StatefulWidget {
  @override
  _AchievementWidgetState createState() => _AchievementWidgetState();
}

class _AchievementWidgetState extends State<AchievementWidget> {
  //订单评价列表
  List<String> commentList;

  //洗涤数量
  String _washCount = '';

  //洗涤提成
  String _washRoyalty = '';

  //洗涤实收金额
  String _washRealPrice = '';

  //鲜花数量
  String _flowerCount = '';

  //鲜花提成
  String _flowerRoyalty = '';

  //鲜花实收金额
  String _flowerRealPrice = '';

  //数据模型中的所有用户评价
  List<DataList> commentAllDataList = [];

  //排名
  String _ranking = '';

  @override
  void initState() {
    commentList = [];
    getRequest(API.YESTERDAY_WAR_INFO, queryParameters: {'user_id': '412'})
        .then((val) {
      print('昨日战况接口:${API.YESTERDAY_WAR_INFO},数据:${val}');
      YesterdayWarInfoModel yesterdayWarInfoModel =
          YesterdayWarInfoModel.fromJson(val);
      if (yesterdayWarInfoModel.code == GlobalData.UNAUTHORIZED_TOKEN) {
        //token失效
        AlertDialogWidget(title: '登陆过期,请重新登陆!').show(context).then((val) {
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => route == null);
        });
      } else if (yesterdayWarInfoModel.status == GlobalData.REQUEST_SUCCESS) {
        //数据返回成功
        List<Query> listQuery = yesterdayWarInfoModel.data.query;
        setState(() {
          for (int i = 0; i < listQuery.length; i++) {
            if (listQuery[i].type == 1) {
              //洗涤数据
              _washCount = listQuery[i].num.toString(); //单数
              _washRoyalty = listQuery[i].realcommission.toString(); //实收金额
              _washRealPrice = listQuery[i].realprice.toString(); //提成
              print(
                  '昨日营收洗涤:_washRealPrice${_washRealPrice},_washRoyalty${_washRoyalty},');
            } else if (listQuery[i].type == 2) {
              //鲜花数据
              _flowerCount = listQuery[i].num.toString(); //单数
              _flowerRoyalty = listQuery[i].realcommission.toString(); //提成
              _flowerRealPrice = listQuery[i].realprice.toString(); //实收金额
              print(
                  '昨日营收鲜花:_flowerRealPrice${_flowerRealPrice},_flowerRoyalty${_flowerRoyalty},');
            }
          }
          List<DataList> commentDataList = yesterdayWarInfoModel.data.list;
          commentAllDataList = commentDataList;
          for (int i = 0; i < commentDataList.length; i++) {
            commentList.add(commentDataList[i].info);
          }
          _ranking = yesterdayWarInfoModel.data.user.num.toString() ?? 0;
          if (_ranking.contains('.')) {
            _ranking = _ranking.split('.')[0];
          }
        });
      } else {
        showToast('网络开小车了,请稍后再试!');
      }
    });
    super.initState();

//    Timer.periodic(Duration(milliseconds: 1000), (timer) {
//      if (timer.tick == 5) {
//        timer.cancel();
//        print("finish");
//      }
//      print("tick ${timer.tick}, timer isActive ${timer.isActive}");
//    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _titleWidget(),
        Container(
          child: Column(
            children: <Widget>[
              _achievementWidget(
                  title: '洗涤',
                  count: _washCount,
                  dolor: _washRealPrice,
                  getDolor: _washRoyalty),
              _achievementWidget(
                  title: '鲜花',
                  count: _flowerCount,
                  dolor: _flowerRealPrice,
                  getDolor: _flowerRoyalty),
//              _rankWidget(),
              _orderCommentWidget(),
              Container(
                width: ScreenUtil().setWidth(750),
                height: AutoLayout.instance.pxToDp(24),
                color: ColorConstant.greyBgColor,
              ),
//              _marketCommentWidget('本店好评率排名第1', '', () {
//                showToast('更多功能正在开发... ');
//              }),
            ],
          ),
        ),
      ],
    );
  }

  //标题栏组件
  Widget _titleWidget() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              top: BorderSide(color: ColorConstant.greyLineColor),
              bottom: BorderSide(color: ColorConstant.greyLineColor))),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(2)),
      height: AutoLayout.instance.pxToDp(80),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: ScreenUtil().setWidth(10),
                height: AutoLayout.instance.pxToDp(32),
                child: Image.asset('images/rectangle_indicator.png'),
              ),
              Padding(
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(17)),
                child: Text(
                  '昨日战况',
                  style: TextStyle(
                      color: Colors.black, fontSize: ScreenUtil().setSp(30)),
                ),
              )
            ],
          ),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              JumpReceive().jump(context, Routes.praiseNumberPage);
            },
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      '我的门店好评率排名:',
                      style: TextStyle(
                          color: ColorConstant.greyTextColor,
                          fontSize: ScreenUtil().setSp(24)),
                    ),
                  ),
                  Container(
                    child: Text(
                      _ranking,
                      style: TextStyle(
                          color: ColorConstant.redTextColor,
                          fontSize: ScreenUtil().setSp(24)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: ScreenUtil().setWidth(16),
                        right: ScreenUtil().setWidth(24)),
                    child: Image.asset(
                      'images/arrow_more.png',
                      width: ScreenUtil().setWidth(8),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  //客户评价
  Widget _orderCommentWidget() {
    return Container(
      height: AutoLayout.instance.pxToDp(80),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: ColorConstant.greyLineColor))),
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
      child: Row(
        children: [
          Text(
            '订单评价:',
            style: TextStyle(
                color: ColorConstant.greyTextColor,
                fontSize: ScreenUtil().setSp(24)),
          ),
          Expanded(
              child: commentList.length == 0
                  ? Container(
                      child: Text(
                        '暂无订单评价',
                        style: TextStyle(
                            color: ColorConstant.greyTextColor,
                            fontSize: ScreenUtil().setSp(24)),
                      ),
                    )
                  : Swiper(
                      autoplay: true,
                      scrollDirection: Axis.vertical,
                      itemCount: commentList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _singleOrderCommentWidget(commentList[index]);
                      },
                    )),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => OrderCommentPage(
                        commentList: commentAllDataList,
                      )));
            },
            child: Container(
              padding: EdgeInsets.only(
                  right: ScreenUtil().setWidth(24),
                  left: ScreenUtil().setWidth(24)),
              child: Image.asset(
                'images/arrow_more.png',
                height: AutoLayout.instance.pxToDp(15),
              ),
            ),
          )
        ],
      ),
    );
  }

  //单个用户评价
  Widget _singleOrderCommentWidget(String commentData) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => OrderCommentPage(
                  commentList: commentAllDataList,
                )));
      },
      child: Container(
        margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
        alignment: Alignment.centerLeft,
        child: Text(
          commentData,
          maxLines: 2,
          style: TextStyle(
              color: ColorConstant.greyTextColor,
              fontSize: ScreenUtil().setSp(24)),
        ),
      ),
    );
  }

  //门店评价排行
  Widget _marketCommentWidget(
      String title, String comment, VoidCallback onTap) {
    List<TextSpan> spans = [];
    TextStyle keywordStyle =
        TextStyle(fontSize: ScreenUtil().setSp(25), color: Colors.orange);
    TextStyle normalStyle =
        TextStyle(fontSize: ScreenUtil().setSp(25), color: Colors.black);
    if (title.contains('本店好评率排名第')) {
      List<String> str = title.split('第');
      spans.add(TextSpan(text: '${str[0]}第', style: normalStyle));
      spans.add(TextSpan(text: str[1], style: keywordStyle));
    } else {
      spans.add(TextSpan(text: comment, style: normalStyle));
    }
    return Container(
      margin: EdgeInsets.only(
          top: AutoLayout.instance.pxToDp(20),
          bottom: AutoLayout.instance.pxToDp(20)),
      padding: EdgeInsets.only(
          right: AutoLayout.instance.pxToDp(20),
          left: AutoLayout.instance.pxToDp(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //富文本的展示
          Container(child: RichText(text: TextSpan(children: spans))),
          Expanded(
              child: Container(
            child: Text(
              comment,
              style: TextStyle(
                  color: Colors.black, fontSize: ScreenUtil().setSp(35)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: onTap,
            child: Container(
              child: Text(
                '更多 >>',
                style: TextStyle(
                    color: Colors.black, fontSize: ScreenUtil().setSp(25)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //个人排行
  Widget _rankWidget() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        showToast('该功能正在开发...');
        return;
//        List<String> listData = ['第一名', '第二名'];
//        Navigator.of(context).push(MaterialPageRoute(
//            builder: (context) => StepNumberPage(
//                  stepNumberList: listData,
//                )));
      },
      child: Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            _singlePeopleWidget('images/head1.jpeg', 'Lucy', '134公里 第3名'),
            _singlePeopleWidget('images/head2.jpg', 'IiIi', '126公里 第10名'),
            _singlePeopleWidget('images/head3.jpeg', 'David', '100公里 第50名'),
          ],
        ),
      ),
    );
  }

  //单个人展示组件
  Widget _singlePeopleWidget(String headImage, String name, String desc) {
    return Expanded(
        child: Container(
      margin: EdgeInsets.only(
          top: AutoLayout.instance.pxToDp(20),
          bottom: AutoLayout.instance.pxToDp(20)),
      child: Column(
        children: <Widget>[
          ClipOval(
            child: Image.asset(
              headImage,
              width: ScreenUtil().setWidth(80),
              height: ScreenUtil().setHeight(80),
            ),
          ),
          Container(
            child: Text(
              name,
              style: TextStyle(
                  color: ColorConstant.blackTextColor,
                  fontSize: ScreenUtil().setSp(28)),
            ),
          ),
          Container(
//            margin: EdgeInsets.only(top: 10),
            child: Text(
              desc,
              style: TextStyle(
                  color: ColorConstant.greyTextColor,
                  fontSize: ScreenUtil().setSp(25)),
            ),
          )
        ],
      ),
    ));
  }

  //业绩组件
  Widget _achievementWidget(
      {String title, String count, String dolor, String getDolor}) {
    return Container(
      height: AutoLayout.instance.pxToDp(59),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(color: ColorConstant.greyLineColor))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                color: ColorConstant.greyTextColor,
                fontSize: ScreenUtil().setSp(26)),
          ),
          Text(
            '${count}单',
            style: TextStyle(
                color: ColorConstant.greyTextColor,
                fontSize: ScreenUtil().setSp(26)),
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '实收金额 ',
                  style: TextStyle(
                      color: ColorConstant.greyTextColor,
                      fontSize: ScreenUtil().setSp(26)),
                ),
                Text(
                  '¥${dolor}',
                  style: TextStyle(
                      color: ColorConstant.blueTextColor,
                      fontSize: ScreenUtil().setSp(26)),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Text(
                  '提成:',
                  style: TextStyle(
                      color: ColorConstant.greyTextColor,
                      fontSize: ScreenUtil().setSp(26)),
                ),
                Text(
                  '¥${getDolor}',
                  style: TextStyle(
                      color: ColorConstant.blueTextColor,
                      fontSize: ScreenUtil().setSp(26)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
