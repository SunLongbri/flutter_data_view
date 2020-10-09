import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/bottom_cupertion_widget.dart';
import 'package:fluttermarketingplus/widgets/camera_gallery_pick_widget/camera_gallery_widget.dart';

//商品拍照列表组件
class GoodsListWidget extends StatefulWidget {
  final VoidStringCallback stringCallback;
  final ListFileCallBack listFileCallBack;

  const GoodsListWidget({Key key, this.stringCallback, this.listFileCallBack})
      : super(key: key);

  @override
  _GoodsListWidgetState createState() => _GoodsListWidgetState();
}

class _GoodsListWidgetState extends State<GoodsListWidget> {
  String _goodsParts; //衣物配件
  List<File> _imageFiles; //衣物被拍照的图片

  @override
  void initState() {
    _goodsParts = '';
    _imageFiles = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AutoLayout.instance.pxToDp(328),
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(20),
          right: ScreenUtil().setWidth(20),
          top: AutoLayout.instance.pxToDp(20)),
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(16), right: ScreenUtil().setWidth(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          CameraGalleryWidget(
            imageSize: 5,
            listFileCallBack: (List<File> imageFileList) {
              _imageFiles = imageFileList;
              widget.listFileCallBack(imageFileList);
            },
          ),
          Expanded(child: _addPartsWidget())
        ],
      ),
    );
  }

  //添加衣物配件组件
  Widget _addPartsWidget() {
    return _goodsParts.isNotEmpty
        ? Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '衣物配件：',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(28),
                      color: ColorConstant.greyTextColor),
                ),
                Text(
                  _goodsParts,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(28),
                      color: ColorConstant.blackTextColor),
                ),
              ],
            ),
          )
        : InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              BottomCupertionWidget(
                      listContent: ["帽子", "毛领", "内衬", "腰带", "袖带", "肩带"])
                  .selectData(context)
                  .then((value) {
                print('衣物配件:${value}');
                setState(() {
                  _goodsParts = value;
                });
                widget.stringCallback(_goodsParts);
              });
            },
            child: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: ScreenUtil().setWidth(8)),
                    width: ScreenUtil().setWidth(36),
                    child: Image.asset('images/add_icon.png'),
                  ),
                  Container(
                    child: Text(
                      '添加衣物配件',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(26),
                          color: ColorConstant.blueTextColor),
                    ),
                  )
                ],
              ),
            ),
          );
  }

  Widget _titleWidget() {
    return Container(
      height: AutoLayout.instance.pxToDp(78),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: ColorConstant.greyLineColor,
      ))),
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(6),
            height: AutoLayout.instance.pxToDp(28),
            color: Colors.black,
          ),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(7)),
            child: Text(
              '商品拍照',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(28),
                  fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(7)),
            child: Text(
              '(必填，至少拍摄3张照片，最多5张照片)',
              style: TextStyle(
                  color: ColorConstant.greyTextColor,
                  fontSize: ScreenUtil().setSp(28)),
            ),
          ),
        ],
      ),
    );
  }
}
