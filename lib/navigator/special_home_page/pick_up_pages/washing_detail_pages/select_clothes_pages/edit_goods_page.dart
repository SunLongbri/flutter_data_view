import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/model/bind_clothes_model.dart';
import 'package:fluttermarketingplus/model/order_detail_model.dart';
import 'package:fluttermarketingplus/model/response_model.dart';
import 'package:fluttermarketingplus/model/upload_bind_image_model.dart';
import 'package:fluttermarketingplus/provider/data_provider.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import 'edit_goods_widgets/code_info_widget.dart';
import 'edit_goods_widgets/comment_widget.dart';
import 'edit_goods_widgets/goods_flaw_widget.dart';
import 'edit_goods_widgets/goods_list_widget.dart';

//编辑商品信息页面
class EditGoodsPage extends StatefulWidget {
  final String goodsCode;
  final String goodsName;
  final String goodsPrice;
  final String orderId;

  const EditGoodsPage(
      {Key key, this.goodsCode, this.goodsName, this.goodsPrice,this.orderId})
      : super(key: key);
  @override
  _EditGoodsPageState createState() => _EditGoodsPageState();
}

class _EditGoodsPageState extends State<EditGoodsPage> {
  String _goodsCode; //商品条码
  String _goodsName; //商品名称
  String _goodsPrice; //商品价格
  String _goodsParts; //商品配件
  List<File> _imageFiles; //商品被拍照的图片

  List<String> _userSelectFlaw; //用户选择的瑕疵品
  String _commentStr; //订单留言

  DataProvider _dataProvider; //获取状态管理数据
  @override
  void initState() {
    _commentStr = '';
    _goodsParts = '';
    _userSelectFlaw = [];
    _imageFiles = [];
    _goodsCode = widget.goodsCode;
    _goodsName = widget.goodsName;
    _goodsPrice = widget.goodsPrice;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _dataProvider = Provider.of<DataProvider>(context);
    return Scaffold(
      appBar: AppBarWidget(
        title: '编辑商品信息',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CodeInfoWidget(
              goodsCode: _goodsCode,
              goodsName: _goodsName,
            ),
            GoodsFlawWidget(
              listStrBlock: (listStr) {
                setState(() {
                  _userSelectFlaw = listStr;
                });
              },
            ),
            CommentWidget(
              commentStr: (commentStr) {
                print('订单留言为:${commentStr}');
                setState(() {
                  _commentStr = commentStr;
                });
              },
            ),
            GoodsListWidget(
              stringCallback: (val) {
                setState(() {
                  _goodsParts = val;
                });
              },
              listFileCallBack: (List<File> imageFiles) {
                setState(() {
                  _imageFiles = imageFiles ?? [];
                });
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: AutoLayout.instance.pxToDp(140),
        child: Container(
          margin: EdgeInsets.only(
              left: ScreenUtil().setWidth(98),
              right: ScreenUtil().setWidth(98),
              top: AutoLayout.instance.pxToDp(20),
              bottom: AutoLayout.instance.pxToDp(40)),
          child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              color: ColorConstant.blueBgColor,
              onPressed: () async {
                if (_imageFiles.length < 3 || _imageFiles.isEmpty) {
                  showToast('给衣物拍照的数量少于预定值!');
                  return;
                }

                BindClothesModel bindClothesModel = BindClothesModel();
                bindClothesModel.orderId = widget.orderId;
                bindClothesModel.type = '专洗';
                bindClothesModel.goodsCid = _dataProvider.getSecondChildKey;
                bindClothesModel.goodsId = _dataProvider.getThirdChildKey;
                bindClothesModel.goodsName = _goodsName;
                bindClothesModel.goodsPrice = double.parse(_goodsPrice);
                bindClothesModel.goodsCode = _goodsCode;
                bindClothesModel.goodsFlaw = _userSelectFlaw;
                bindClothesModel.goodsMark = _commentStr;
                bindClothesModel.goodsParts = _goodsParts;
                print('绑码操作上传的数据模型为:${json.encode(bindClothesModel)}');
                postRequest(API.BIND_GOODS, json.encode(bindClothesModel),
                        tempBaseUrl: API.TEST_BASE_URL)
                    .then((value) async {
                  ResponseModel responseModel = ResponseModel.fromJson(value);
                  if (responseModel.code == 200) {
                    //将绑定的衣物保存下来
                    String goodsUrl = GlobalData.prefs.getString('goods_url');
                    GoodsList goodsList = GoodsList();
                    goodsList.goodsUrl = [goodsUrl];
                    goodsList.goodsName = _goodsName;
                    goodsList.goodsPrice = double.parse(_goodsPrice);
                    goodsList.goodsFlawMark = _commentStr;
                    goodsList.goodsNum = _goodsCode;
                    goodsList.goodsParts = _goodsParts;
                    goodsList.id = responseModel.data;
                    List<GoodsList> _confirmGoodsList = _dataProvider.getConfirmGoodsList;
                    _confirmGoodsList.add(goodsList);
                    _dataProvider.setConfirmGoodsList = _confirmGoodsList;

                    String barcodeId = responseModel.data;
                    Navigator.pop(context, '绑码完成');

                    UploadBindImageModel uploadBindImageModel =
                        UploadBindImageModel();
                    uploadBindImageModel.orderId =
                        widget.orderId;
                    uploadBindImageModel.goodsCode = _goodsCode;
                    uploadBindImageModel.barcodeId = barcodeId;
                    uploadBindImageModel.goodsFiles = _imageFiles;

                    FormData formData = FormData.fromMap({
                      "orderId": widget.orderId,
                      "goodsCode": _goodsCode,
                      "barcodeId": barcodeId,
                    });

                    List<MapEntry<String, MultipartFile>> imageFiles = [];
                    for (int i = 0; i < _imageFiles.length; i++) {
                      print('文件名为:${_imageFiles[i].path}');
                      List<String> fileName = _imageFiles[i].path.split('/');

                      imageFiles.add(MapEntry(
                        "goodsFiles",
                        await MultipartFile.fromFile(_imageFiles[i].path,
                            filename: fileName[fileName.length - 1]),
                      ));
                    }

                    formData.files.addAll(imageFiles);

                    postFileRequest(API.UPLOAD_GOODS_IMAGES, formData,
                            tempBaseUrl: API.TEST_BASE_URL)
                        .then((val) {
                      print('上传的formData:${formData}');
                      print('上传图片的结果:${val}');
                      ResponseModel responseModel = ResponseModel.fromJson(val);
                      if (responseModel.code == 200) {
                        showToast('图片上传成功！');
                      }
                    });
                  }
                });
              },
              child: Text(
                '绑码完成',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(32), color: Colors.white),
              )),
        ),
      ),
    );
  }
}
