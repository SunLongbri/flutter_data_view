import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/model/pickup_route_model.dart';
import 'package:fluttermarketingplus/provider/data_provider.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:provider/provider.dart';

import 'single_card_widget.dart';

//取件控制面板
class PickUpPanelWidget extends StatefulWidget {
  @required
  final ScrollController scrollController;

  const PickUpPanelWidget({Key key, this.scrollController}) : super(key: key);

  @override
  _PickUpPanelWidgetState createState() => _PickUpPanelWidgetState();
}

class _PickUpPanelWidgetState extends State<PickUpPanelWidget> {
  ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = widget.scrollController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DataProvider _dataProvider = Provider.of<DataProvider>(context);
    List<Widget> widgets = [];
    widgets.add(_topLineWidget());
    List<PickUpTask> pickUpTaskList = _dataProvider.getPickUpTaskList;
    if (pickUpTaskList != null) {
      int unAccept = 0;
      for (int i = 0; i < pickUpTaskList.length; i++) {
        if(pickUpTaskList[i].orderType ==1){
          unAccept ++;
        }
        widgets.add(SingleCardWidget(
          totalIndex: pickUpTaskList[i].pickUpIndex == null
              ? pickUpTaskList.length
              : (pickUpTaskList.length - 1 -(unAccept -1)),
          orderIndex: pickUpTaskList[i].pickUpIndex ?? (i + 1),
          orderAddress: pickUpTaskList[i].orderAddress,
          orderTime: pickUpTaskList[i].orderTime,
          orderMark: pickUpTaskList[i].orderMark,
          type: pickUpTaskList[i].pickUpIndex == null ? '送' : '取',
          orderId: pickUpTaskList[i].orderId,
          pickUpTask: pickUpTaskList[i],
        ));
      }
    }

    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          controller: _scrollController,
          children: widgets,
        ));
  }

  Widget _button(String label, IconData icon, Color color) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Icon(
            icon,
            color: Colors.white,
          ),
          decoration:
              BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              blurRadius: 8.0,
            )
          ]),
        ),
        SizedBox(
          height: 12.0,
        ),
        Text(label),
      ],
    );
  }

  //顶部横线组件
  Widget _topLineWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
              top: AutoLayout.instance.pxToDp(14),
              bottom: AutoLayout.instance.pxToDp(34)),
          width: ScreenUtil().setWidth(50),
          height: AutoLayout.instance.pxToDp(4),
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
        ),
      ],
    );
  }
}
