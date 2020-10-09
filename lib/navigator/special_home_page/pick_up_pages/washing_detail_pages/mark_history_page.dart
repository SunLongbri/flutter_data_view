import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/model/mark_history_model.dart';
import 'package:fluttermarketingplus/provider/data_provider.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';
import 'package:fluttermarketingplus/widgets/loading_container.dart';
import 'package:provider/provider.dart';

//留言历史记录
class MarkHistoryPage extends StatefulWidget {
  final String orderId;

  const MarkHistoryPage({Key key, this.orderId}) : super(key: key);

  @override
  _MarkHistoryPageState createState() => _MarkHistoryPageState();
}

class _MarkHistoryPageState extends State<MarkHistoryPage> {
  List<HistoryMarks> _historyMarksList;
  bool _isLoading;
  DataProvider _dataProvider;

  @override
  void initState() {
    _isLoading = true;
    _historyMarksList = [];
    var formData = {"orderNumber": widget.orderId};
    postRequest(API.ORDER_HISTORY_MARK, formData,
            tempBaseUrl: API.TEST_BASE_URL)
        .then((value) {
      print('留言历史记录:${value}');
      MarkHistoryModel markHistoryModel = MarkHistoryModel.fromJson(value);
      if (markHistoryModel.code == 200) {
        setState(() {
          _isLoading = false;
          _historyMarksList = markHistoryModel?.data?.historyMarks ?? [];
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _dataProvider = Provider.of<DataProvider>(context);
    return Scaffold(
      appBar: AppBarWidget(
        title: '历史备注',
        backPress: () {
          _dataProvider.isRefresh = true;
          Navigator.pop(context);
        },
      ),
      body: LoadingContainer(
          isLoading: _isLoading,
          cover: true,
          child: Container(
            margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(20),
                right: ScreenUtil().setWidth(20)),
            child: ListView.builder(
                itemCount: _historyMarksList.length,
                itemBuilder: (BuildContext context, int position) {
                  return _singleMarkWidget(_historyMarksList[position].markTime,
                      _historyMarksList[position].markContent);
                }),
          )),
    );
  }

  //单个留言组件
  Widget _singleMarkWidget(String markTime, String markContent) {
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setWidth(20)),
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(20), right: ScreenUtil().setWidth(20)),
      height: AutoLayout.instance.pxToDp(132),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(7))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  markTime,
                  style: TextStyle(
                      color: Color(0xffCCCCCC),
                      fontSize: ScreenUtil().setSp(24)),
                ),
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
              child: Text(
                markContent,
                style: TextStyle(
                    color: Color(0xff999999), fontSize: ScreenUtil().setSp(25)),
              ))
        ],
      ),
    );
  }
}
