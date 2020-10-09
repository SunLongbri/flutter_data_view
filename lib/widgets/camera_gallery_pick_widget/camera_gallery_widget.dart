import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'single_image_widget.dart';

typedef FileCallBack = void Function(File);
typedef ListFileCallBack = void Function(List<File>);
class CameraGalleryWidget extends StatefulWidget {
  final int imageSize;
  final ListFileCallBack listFileCallBack;
  const CameraGalleryWidget({Key key, this.imageSize,this.listFileCallBack})
      : super(key: key); //展示图片的数量

  @override
  _CameraGalleryWidgetState createState() => _CameraGalleryWidgetState();
}

class _CameraGalleryWidgetState extends State<CameraGalleryWidget> {
  List<File> _imageFile;
  ListFileCallBack _listFileCallBack;
  @override
  void initState() {
    _imageFile = [];
    _listFileCallBack = widget.listFileCallBack;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(750),
      height: AutoLayout.instance.pxToDp(140),
      margin: EdgeInsets.only(top: AutoLayout.instance.pxToDp(20)),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.imageSize,
        itemBuilder: (BuildContext context, int position) {
          return SingleImageWidget(
            imageBlock: (File imageFile) {
              setState(() {
                if (imageFile != null) {
                  _imageFile.add(imageFile);
                } else {
                  if (_imageFile.contains(imageFile)) {
                    _imageFile.remove(imageFile);
                  }
                }
              });
              _listFileCallBack(_imageFile);
            },
          );
        },
      ),
    );
  }
}
