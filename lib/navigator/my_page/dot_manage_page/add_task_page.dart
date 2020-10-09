import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/login/login_page.dart';
import 'package:fluttermarketingplus/model/add_task_upload_model.dart';
import 'package:fluttermarketingplus/model/comment_model.dart';
import 'package:fluttermarketingplus/model/single_user_data_model.dart';
import 'package:fluttermarketingplus/model/task_deliver_list_model.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/alert_dialog_widget.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';
import 'package:fluttermarketingplus/widgets/loading_container.dart';
import 'package:fluttermarketingplus/widgets/single_select_indicator_widget.dart';
import 'package:oktoast/oktoast.dart';

//店长：新增任务页面
class AddTaskPage extends StatefulWidget {
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  List<UserData> _userList;
  bool _isLoading;
  String flag;
  List<String> _tabList;

  @override
  void initState() {
    _isLoading = true;
    flag = '1'; //默认数据为下周
    _tabList = ['下周', '下个月', '下个季度', '明年'];
    _userList = [];
    _initUserList();
    super.initState();
  }

  void _initUserList() {
    Map<String, String> queryParameters = {'user_id': '461'};
    setState(() {
      _isLoading = true;
    });
    getRequest(API.ADD_TASK_LIST, queryParameters: queryParameters).then((val) {
      print('val:${val}');
      setState(() {
        _isLoading = false;
        TaskDeliverListModel taskDeliverListModel =
            TaskDeliverListModel.fromJson(val);
        if (taskDeliverListModel.code == GlobalData.UNAUTHORIZED_TOKEN) {
          //token失效
          AlertDialogWidget(title: '登陆过期,请重新登陆!').show(context).then((val) {
            Navigator.of(context).pushAndRemoveUntil(
                new MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => route == null);
          });
        } else if (taskDeliverListModel.status == GlobalData.REQUEST_SUCCESS) {
          List<Data> _dataList = taskDeliverListModel.data;
          for (int i = 0; i < _dataList.length; i++) {
            UserData userData = UserData(
                userId: _dataList[i].userId,
                stationId: _dataList[i].stationId,
                nickname: _dataList[i].nickname,
                account: _dataList[i].account,
                flowerCountController: TextEditingController(),
                flowerRealMoneyController: TextEditingController(),
                washCountController: TextEditingController(),
                washRealMoneyController: TextEditingController());
            _userList.add(userData);
          }
        } else {
          showToast('网络开小车了,请稍后再试!');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '新增任务',
        actionsWidget: _completeWidget(),
      ),
      body: LoadingContainer(
        isLoading: _isLoading,
        cover: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _singleSelectBar(),
            _titleBar(),
            _dataList(),
          ],
        ),
      ),
    );
  }

  //完成组件
  Widget _completeWidget() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        AlertDialogWidget(title: '是否添加当前分配任务?').show(context).then((val) {
          _uploadTask();
        });
      },
      child: Container(
        width: ScreenUtil().setWidth(44),
        child: Image.asset(
          'images/complete.png',
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  //上传当前店长分配给小哥的任务
  void _uploadTask() {
    AddTaskUploadModel addTaskUploadModel = AddTaskUploadModel();
    addTaskUploadModel.flag = flag;
    addTaskUploadModel.stationId = _userList[0]?.stationId ?? '';
    List<Task> taskList = [];
    for (int i = 0; i < _userList.length; i++) {
      String flowerCount =
          _userList[i].flowerCountController.text.trim().toString();
      String flowerRealMoney =
          _userList[i].flowerRealMoneyController.text.trim().toString();
      String washCount =
          _userList[i].washCountController.text.trim().toString();
      String washRealMoney =
          _userList[i].washRealMoneyController.text.trim().toString();
      Task task = Task(
          userId: _userList[i].userId,
          userName: _userList[i].nickname,
          flowerCount: flowerCount.isEmpty ? '0' : flowerCount,
          flowerMoney: flowerRealMoney.isEmpty ? '0' : flowerRealMoney,
          washCount: washCount.isEmpty ? '0' : washCount,
          washMoney: washRealMoney.isEmpty ? '0' : washRealMoney);
      taskList.add(task);
    }
    addTaskUploadModel.task = taskList;
    print('上传的数据模型为:${addTaskUploadModel.toJson()}');
    setState(() {
      _isLoading = true;
    });
    postRequest(API.ADD_TASK_UPLOAD, addTaskUploadModel.toJson()).then((val) {
      setState(() {
        _isLoading = false;
      });
      print('val:${val}');
      CommentInfoModel commentInfoModel = CommentInfoModel.fromJson(val);
      if (commentInfoModel.code == GlobalData.UNAUTHORIZED_TOKEN) {
        //token失效
        AlertDialogWidget(title: '登陆过期,请重新登陆!').show(context).then((val) {
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => route == null);
        });
      } else if (commentInfoModel.status == GlobalData.REQUEST_SUCCESS) {
        showToast('任务量添加成功！');
        Navigator.pop(context);
      }
    });
  }

  //单选bar
  Widget _singleSelectBar() {
    return SingleSelectIndicatorWidget(
      paddingBottom: 1,
      listContent: _tabList,
      stringBlock: (content) {
        print('新增任务：${content}');
        setState(() {
          if (content.compareTo(_tabList[0]) == 0) {
            flag = '1';
          } else if (content.compareTo(_tabList[1]) == 0) {
            flag = '2';
          } else if (content.compareTo(_tabList[2]) == 0) {
            flag = '3';
          } else if (content.compareTo(_tabList[3]) == 0) {
            flag = '4';
          }
        });
      },
    );
  }

  //标题栏
  Widget _titleBar() {
    return Container(
      height: AutoLayout.instance.pxToDp(78),
      margin: EdgeInsets.only(top: AutoLayout.instance.pxToDp(24)),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          _singleColumnWidget('姓名'),
          _singleColumnWidget('鲜花单量'),
          _singleColumnWidget('鲜花实收金额'),
          _singleColumnWidget('洗涤单量'),
          _singleColumnWidget('洗涤实收金额'),
        ],
      ),
    );
  }

  //数据列表
  Widget _dataList() {
    return Expanded(
        child: Container(
      color: Colors.white,
      child: ListView.builder(
          itemCount: _userList.length,
          itemBuilder: (BuildContext context, int position) {
            return _singleRowWidget(
                _userList[position].nickname,
                _userList[position].flowerCountController,
                _userList[position].flowerRealMoneyController,
                _userList[position].washCountController,
                _userList[position].washRealMoneyController);
          }),
    ));
  }

  //标题单个单元格
  Widget _singleColumnWidget(String content) {
    return Expanded(
        child: Container(
      alignment: Alignment.center,
      height: AutoLayout.instance.pxToDp(70),
      child: Text(
        content,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: ColorConstant.blackTextColor,
            fontSize: ScreenUtil().setSp(26)),
      ),
    ));
  }

  //数据存储单行
  Widget _singleRowWidget(
      String name,
      TextEditingController controller1,
      TextEditingController controller2,
      TextEditingController controller3,
      TextEditingController controller4) {
    return Container(
      margin: EdgeInsets.only(bottom: AutoLayout.instance.pxToDp(10)),
      padding: EdgeInsets.only(
          bottom: AutoLayout.instance.pxToDp(10),
          top: AutoLayout.instance.pxToDp(10)),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: ColorConstant.greyLineColor))),
      child: Row(
        children: [
          Expanded(
              child: Container(
            alignment: Alignment.center,
            width: ScreenUtil().setWidth(70),
            child: Text(
              name,
              style: TextStyle(
                  color: Colors.black, fontSize: ScreenUtil().setSp(25)),
            ),
          )),
          _singleTableWidget(
            controller1,
          ),
          _singleTableWidget(
            controller2,
          ),
          _singleTableWidget(
            controller3,
          ),
          _singleTableWidget(
            controller4,
          ),
        ],
      ),
    );
  }

  //数据存储单元格
  Widget _singleTableWidget(
    TextEditingController textEditingController,
  ) {
    return Expanded(
        child: Container(
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(10), right: ScreenUtil().setWidth(10)),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: ColorConstant.greyTextColor),
          borderRadius: BorderRadius.circular(5)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 30, maxWidth: 200),
        child: TextField(
          controller: textEditingController,
          keyboardType: TextInputType.number,
          style: TextStyle(fontSize: ScreenUtil().setSp(25)),
          cursorColor: ColorConstant.greyLineColor,
          decoration: InputDecoration(
            hintText: '0',
            contentPadding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none),
          ),
        ),
      ),
    ));
  }
}
