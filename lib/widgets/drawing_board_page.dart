import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/model/order_detail_model.dart';
import 'package:fluttermarketingplus/model/response_model.dart';
import 'package:fluttermarketingplus/model/upload_confirm_order_model.dart';
import 'package:fluttermarketingplus/navigator/special_home_page/pick_up_pages/washing_detail_page.dart';
import 'package:fluttermarketingplus/provider/data_provider.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui show ImageByteFormat, Image;

import 'package:provider/provider.dart';

/// Description: 签名画板并截图
class DrawingBoardPage extends StatefulWidget {
  final String orderId;
  final List<String> partGoodsList;
  final int allCount;
  final UploadConfirmOrderModel uploadConfirmOrderModel;

  const DrawingBoardPage(
      {Key key,
      this.orderId,
      this.partGoodsList,
      this.allCount,
      this.uploadConfirmOrderModel})
      : super(key: key);

  @override
  _DrawingBoardPageState createState() => _DrawingBoardPageState();
}

class _DrawingBoardPageState extends State<DrawingBoardPage> {
  /// 标记签名画板的Key，用于截图
  GlobalKey _globalKey;

  /// 已描绘的点
  List<Offset> _points = <Offset>[];

  /// 记录截图的本地保存路径
  String _imageLocalPath;

  //部分签收商品单号数组
  List<String> _partGoodsList;

  //订单编号
  String _orderId;
  DataProvider _dataProvider;
  int _allCount; //全部订单数据

  @override
  void initState() {
    _orderId = widget.orderId;
    _partGoodsList = widget.partGoodsList ?? [];
    _allCount = widget.allCount ?? 0;
    super.initState();
    _globalKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    _dataProvider = Provider.of<DataProvider>(context);
    return Scaffold(
      appBar: AppBarWidget(title: '客户签字'),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(11.0, 12.0, 11.0, 0.0),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(bottom: AutoLayout.instance.pxToDp(24)),
              color: Colors.white,
              child: Text(
                '$_orderId—泰笛洗涤—合计${_allCount == 0 ? _partGoodsList.length : _allCount}件',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(30),
                    color: ColorConstant.greyTextColor),
              ),
            ),
            _drawPaintAreaWidget(),
            _textInfoWidget(),
            _singleSignBtn('重新签名'),
            _singleSignBtn('确认凭证'),
          ],
        ),
      ),
    );
  }

  //单个签名按钮
  Widget _singleSignBtn(String btnName) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () async {
        if (btnName == '重新签名') {
          setState(() {
            _points?.clear();
            _points = [];
            _imageLocalPath = null;
          });
        } else if (btnName == '确认凭证') {
          File toFile = await _saveImageToFile();
          _imageLocalPath = await _capturePng(toFile);

          if (widget.uploadConfirmOrderModel != null) {
            //取件-确认订单--->已受理到已取件
            print(
                '已受理到已取件---上传的数据模型为:${json.encode(widget.uploadConfirmOrderModel)}');
            postRequest(API.CONFIRM_ORDER_STATE, widget.uploadConfirmOrderModel,
                    tempBaseUrl: API.TEST_BASE_URL)
                .then((value) {
              ResponseModel responseModel = ResponseModel.fromJson(value);
              if (responseModel.code == 200) {
                _dataProvider.setGoodsList = [];
                _dataProvider.setUserSelectTab = '上衣';
                _dataProvider.setTotalPrice = .0;
                _dataProvider.setTempCountMap = Map();
                _dataProvider.setConfirmGoodsList = [];
                showToast('当前状态变为已取件！');
                _uploadSignImage();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => WashingDetailPage(
                          washingId: _orderId,
                        ))).then((value){
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                });
              } else {
                showToast(responseModel.message);
              }
            });
          } else {
            //送件-客户确认签收--->派送中到已签收
            if (_partGoodsList.isNotEmpty) {
              //部分签收
              _dataProvider.setOrderPayState = '';
              var formData = {
                "goodsNumList": _partGoodsList,
                "orderNumber": _orderId
              };
              postRequest(API.PARTICAL_RECEIPT, formData,
                      tempBaseUrl: API.TEST_BASE_URL)
                  .then((value) {
                print('部分签收:${value}');
                ResponseModel responseModel = ResponseModel.fromJson(value);
                if (responseModel.code == 200) {
                  _uploadSignImage();
                  _dataProvider.setPartSignForState = false;
                  _dataProvider.setPartsGoodsList = [];
                  showToast(responseModel.message);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => WashingDetailPage(
                            washingId: _orderId,
                          ))).then((value){
                            Navigator.pop(context);
                            Navigator.pop(context);
                  });
                } else {
                  showToast(responseModel.message);
                }
              });
            } else {
              //全部订单签收
              var formData = {'orderNumber': _orderId};
              postRequest(API.SING_FOR_GOODS, formData,
                      tempBaseUrl: API.TEST_BASE_URL)
                  .then((value) {
                print('全部订单签收:${value}');
                ResponseModel responseModel = ResponseModel.fromJson(value);
                if (responseModel.code == 200) {
                  showToast(responseModel.message);
                  //跳转到客户签名页面
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => WashingDetailPage(
                            washingId: _orderId,
                          ))).then((value){
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
                } else {
                  showToast(responseModel.message);
                }
              });
            }
          }
        }
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: btnName == '确认凭证' ? ColorConstant.blueBgColor : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(100)),
            border: Border.all(color: ColorConstant.blueTextColor)),
        height: AutoLayout.instance.pxToDp(70),
        margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(94),
            right: ScreenUtil().setWidth(92),
            bottom: AutoLayout.instance.pxToDp(24)),
        child: Text(
          btnName,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(32),
              color: btnName == '确认凭证'
                  ? Colors.white
                  : ColorConstant.blueTextColor),
        ),
      ),
    );
  }

  _uploadSignImage() {
    //上传客户签名图片
    Future.delayed(Duration(milliseconds: 1000)).then((e) async {
      String fileName = _imageLocalPath.split('/').last;
      print('上传图片的文件名:${fileName}');
      MultipartFile file =
          await MultipartFile.fromFile(_imageLocalPath, filename: fileName);
      FormData formData =
          FormData.fromMap({"orderId": widget.orderId, "customerSign": file});

      postFileRequest(API.CONFIRM_SIGN, formData,
              tempBaseUrl: API.TEST_BASE_URL)
          .then((val) {
        print('上传图片的结果:${val}');
        ResponseModel responseModel = ResponseModel.fromJson(val);
        if (responseModel.code == 200) {
          showToast('图片上传成功！');
        }
      });
    });
  }

  Widget _textInfoWidget() {
    return Container(
      margin: EdgeInsets.only(
          top: AutoLayout.instance.pxToDp(34),
          bottom: AutoLayout.instance.pxToDp(38)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(40),
            child: Image.asset(
              'images/hand_point.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
            child: Text(
              '请在上方空白区域签字确认',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(30),
                  color: ColorConstant.blueTextColor),
            ),
          )
        ],
      ),
    );
  }

  //签字区域组件
  Widget _drawPaintAreaWidget() {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey, width: 0.5),
      ),
      child: RepaintBoundary(
        key: _globalKey,
        child: Stack(
          children: [
            GestureDetector(
              onPanUpdate: (details) => _addPoint(details),
              onPanEnd: (details) => _points.add(null),
            ),
            CustomPaint(painter: BoardPainter(_points)),
          ],
        ),
      ),
    ));
  }

  /// 添加点，注意不要超过Widget范围
  _addPoint(DragUpdateDetails details) {
    RenderBox referenceBox = _globalKey.currentContext.findRenderObject();
    Offset localPosition = referenceBox.globalToLocal(details.globalPosition);
    double maxW = referenceBox.size.width;
    double maxH = referenceBox.size.height;
    // 校验范围
    if (localPosition.dx <= 0 || localPosition.dy <= 0) return;
    if (localPosition.dx > maxW || localPosition.dy > maxH) return;
    setState(() {
      _points = List.from(_points)..add(localPosition);
    });
  }

  /// 选取保存文件的路径
  Future<File> _saveImageToFile() async {
    Directory tempDir = await getTemporaryDirectory();
    int curT = DateTime.now().millisecondsSinceEpoch;
    String toFilePath = '${tempDir.path}/$curT.png';
    File toFile = File(toFilePath);
    bool exists = await toFile.exists();
    if (!exists) {
      await toFile.create(recursive: true);
    }
    return toFile;
  }

  /// 截图，并且返回图片的缓存地址
  Future<String> _capturePng(File toFile) async {
    // 1. 获取 RenderRepaintBoundary
    RenderRepaintBoundary boundary =
        _globalKey.currentContext.findRenderObject();
    // 2. 生成 Image
    ui.Image image = await boundary.toImage();
    // 3. 生成 Uint8List
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    // 4. 本地存储Image
    toFile.writeAsBytes(pngBytes);
    return toFile.path;
  }
}

class BoardPainter extends CustomPainter {
  BoardPainter(this.points);

  final List<Offset> points;

  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  bool shouldRepaint(BoardPainter other) => other.points != points;
}
