import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/model/attendance_model.dart';
import 'package:fluttermarketingplus/routers/jump_receive.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';
import 'package:fluttermarketingplus/widgets/single_select_indicator_widget.dart';
import 'package:fluttermarketingplus/widgets/tabbarview_widget.dart';

/**
 * 出勤情况 04/09
 */

var _tabs = ['上周', '上月'];
List<Widget> tabList;
TabController _tabController;

var viewList = [
  Page1(),
  Page2(),
];

class AttendancePage extends StatefulWidget {
  final String titleData;

  const AttendancePage({Key key, this.titleData}) : super(key: key);

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage>
    with SingleTickerProviderStateMixin {
  String _titledata;

  @override
  void initState() {
    super.initState();
    _titledata = JumpReceive().receive(widget.titleData);
    tabList = getTabList();
    _tabController = TabController(vsync: this, length: _tabs.length);
  }

  List<Widget> getTabList() {
    return _tabs
        .map((item) => Text(
              '$item',
              style: TextStyle(fontSize: 15),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBarWidget(
        title: _titledata,
//            child: TabBar(
//              tabs: tabList,
//              isScrollable: true,
//              controller: _tabController,
//              indicatorColor: Colors.blueAccent,
//              unselectedLabelColor: Colors.black38,
//              labelColor: Colors.blueAccent,
//              indicatorSize: TabBarIndicatorSize.tab,
//        ),
      ),
      body: Column(
        children: <Widget>[
          SingleSelectIndicatorWidget(
            listContent: _tabs,
            paddingBottom: 0,
            paddingLeft: 40,
            paddingRight: 40,
            stringBlock: (selectContent) {
              print('选择的内容为:${selectContent}...');
            },
          ),
          Expanded(
            child:  Page1(),
          ),


//            TabBarViewWidget(
//              tabController: _tabController,
//              viewList: viewList,
//            ),
        ],
      ),
//      ),
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
//      margin: EdgeInsets.only(top: 12.0),
        child: ListView(
          children: <Widget>[
            DataTable(
              columns: [
                DataColumn(
                  label: Text(
                    '姓名',
                    style: TextStyle(
                      color: ColorConstant.greyTextColor,fontSize: ScreenUtil().setSp(26),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text('工号',style: TextStyle(
                    color: ColorConstant.greyTextColor,fontSize: ScreenUtil().setSp(26),
                  ),),
                ),
                DataColumn(
                  label: Text('出勤天数',style: TextStyle(
                    color: ColorConstant.greyTextColor,fontSize: ScreenUtil().setSp(26),
                  ),),
                ),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text(attendanceList[0].name)),
                    DataCell(Text(attendanceList[0].id)),
                    DataCell(Text(attendanceList[0].dayNum)),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text(attendanceList[1].name)),
                    DataCell(Text(attendanceList[1].id)),
                    DataCell(Text(attendanceList[1].dayNum)),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text(attendanceList[2].name)),
                    DataCell(Text(attendanceList[2].id)),
                    DataCell(Text(attendanceList[2].dayNum)),
                  ],
                ),
              ],
            ),
          ],

      ),
    );
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('build Page2');

    return Center(
      child: Text('Page2'),
    );
  }
}
