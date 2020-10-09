import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/model/pickup_route_model.dart';
import 'package:fluttermarketingplus/navigator/special_home_page/pick_up_pages/calendar_test_page.dart';
import 'package:fluttermarketingplus/navigator/special_home_page/pick_up_pages/washing_detail_page.dart';
import 'package:fluttermarketingplus/navigator/special_home_page/pick_up_pages/washing_detail_pages/calendar_info_page.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:oktoast/oktoast.dart';

//单个受理卡片组件
class SingleCardWidget extends StatefulWidget {
  final int orderIndex;
  final int totalIndex;
  final String orderAddress;
  final String orderTime;
  final String orderMark;
  final String type;
  final String orderId;
  final PickUpTask pickUpTask;

  const SingleCardWidget(
      {Key key,
      this.orderIndex,
      this.orderAddress,
      this.orderTime,
      this.totalIndex,
      this.type,
      this.orderMark,
      this.orderId,
      this.pickUpTask})
      : super(key: key);

  @override
  _SingleCardWidgetState createState() => _SingleCardWidgetState();
}

class _SingleCardWidgetState extends State<SingleCardWidget> {

  int _orderIndex;
  @override
  void initState() {
    _orderIndex = widget.orderIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[_orderStatusWidget(), _orderInfoWidget()],
      ),
    );
  }

  //订单状态组件
  Widget _orderStatusWidget() {
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(32)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(50),
                height: AutoLayout.instance.pxToDp(60),
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage(
                    widget.type == '取'
                        ? widget.orderIndex == 0
                            ? 'images/accept_icon.png'
                            : 'images/get_empty.png'
                        : 'images/yellow_empty.png',
                  ),
                )),
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(top: AutoLayout.instance.pxToDp(8)),
                child: Text(
                  widget.orderIndex == 0 ? '' : widget.orderIndex.toString(),
                  style: TextStyle(
                      color: Colors.white, fontSize: ScreenUtil().setSp(25)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                width: ScreenUtil().setWidth(36),
                child: Image.asset(
                  'images/group_text.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
              widget.type == '取'
                  ? Container(
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(14)),
                      child: Text(
                        widget.orderTime,
                        style: TextStyle(
                            color: ColorConstant.greyTextColor,
                            fontSize: ScreenUtil().setSp(28)),
                      ),
                    )
                  : Container()
            ],
          ),
          widget.type == '取'
              ? _operationBtnWidget(widget.orderIndex)
              : Container()
        ],
      ),
    );
  }

  //操作按钮组件 operateType:0,未受理，其他：已受理
  Widget _operationBtnWidget(int operateType) {
    String btnText = '';
    if (operateType == 0) {
      btnText = '受理';
    } else {
      btnText = '重设';
    }
    return Container(
      margin: EdgeInsets.only(right: ScreenUtil().setWidth(44)),
      height: AutoLayout.instance.pxToDp(60),
      child: FlatButton(
          color:
              operateType == 0 ? ColorConstant.redBgColor : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
            side: operateType == 0
                ? BorderSide(color: Colors.transparent)
                : BorderSide(color: Color(0xff4EB8FB), width: 1),
          ),
          onPressed: () {
            if (operateType == 0) {
              //受理
//              Navigator.of(context).push(MaterialPageRoute(
//                  builder: (context) => CalendarInfoPage(
//                        pickUpTask: widget.pickUpTask,
//                      )));
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CalendarTestPage(pickUpTask: widget.pickUpTask,))).then((value){
                    print('刷新重设时间');
              });
            } else {
              //重设
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CalendarTestPage(
                        pickUpTask: widget.pickUpTask,
                      )));
            }
          },
          child: Text(
            btnText,
            style: TextStyle(
                color: operateType == 0 ? Colors.white : Color(0xff4EB8FB),
                fontSize: ScreenUtil().setSp(28)),
          )),
    );
  }

  //订单地址及信息组件
  Widget _orderInfoWidget() {
//    print('定位：orderIdex:${widget.orderIndex},totalIndex:${widget.totalIndex}');
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(32)),
      child: Row(
        children: <Widget>[
          widget.orderIndex == 0
              ? Container(
                  width: ScreenUtil().setWidth(50),
                  height: AutoLayout.instance.pxToDp(132),
                )
              : widget.orderIndex == widget.totalIndex
                  ? Container(
                      width: ScreenUtil().setWidth(50),
                      height: AutoLayout.instance.pxToDp(132),
                    )
                  : Container(
                      alignment: Alignment.center,
                      width: ScreenUtil().setWidth(50),
                      height: AutoLayout.instance.pxToDp(132),
                      child: Container(
                        width: ScreenUtil().setWidth(4),
                        color: widget.type == '取'
                            ? Color(0xff35C7BA)
                            : Color(0xffEA9B48),
                      ),
                    ),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.orderAddress,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: ColorConstant.blackTextColor,
                      fontFamily: 'PingFang',
                      fontWeight: FontWeight.w600,
                      fontSize: ScreenUtil().setSp(30)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      widget.orderMark.isEmpty ? '无' : widget.orderMark,
                      maxLines: 1,
                      style: TextStyle(
                          color: ColorConstant.greyTextColor,
                          fontFamily: 'PingFang',
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenUtil().setSp(30)),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => WashingDetailPage(
                                  washingId: widget.orderId,
                                )));
                      },
                      child: Container(
                        margin:
                            EdgeInsets.only(right: ScreenUtil().setWidth(38)),
                        child: Text(
                          '详情',
                          style: TextStyle(
                              color: ColorConstant.blueTextColor,
                              fontFamily: 'PingFang',
                              fontWeight: FontWeight.w500,
                              fontSize: ScreenUtil().setSp(30)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
