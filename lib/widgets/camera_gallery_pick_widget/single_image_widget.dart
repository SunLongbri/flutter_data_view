import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:image_picker/image_picker.dart';

import 'camera_gallery_widget.dart';

//单个相片组件
class SingleImageWidget extends StatefulWidget {
  final FileCallBack imageBlock; //图片文件返回block

  const SingleImageWidget({Key key, this.imageBlock}) : super(key: key);

  @override
  _SingleImageWidgetState createState() => _SingleImageWidgetState();
}

class _SingleImageWidgetState extends State<SingleImageWidget> {
  FileCallBack _imageBlock; //用于返回图片文件
  File _image; // 图片文件
  ImagePicker _picker; //图片选择

  @override
  void initState() {
    _imageBlock = widget.imageBlock;
    _picker = ImagePicker();
    super.initState();
  }

  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            showCupertinoModalPopup(
              context: context,
              builder: (context) {
                return CupertinoActionSheet(
                  title: Text('选择图片来源',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                      )),
                  cancelButton: CupertinoActionSheetAction(
                    child: Text('取消'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  actions: <Widget>[
                    CupertinoActionSheetAction(
                      child: Text('拍照'),
                      onPressed: () async {
                        Navigator.pop(context);
                        final pickedFile =
                            await _picker.getImage(source: ImageSource.camera);
                        setState(() {
                          _image = File(pickedFile.path);
                        });
                        _imageBlock(_image);
                      },
                    ),
                    CupertinoActionSheetAction(
                      child: Text('相册'),
                      onPressed: () async {
                        Navigator.pop(context);
                        final pickedFile =
                            await _picker.getImage(source: ImageSource.gallery);
                        setState(() {
                          _image = File(pickedFile.path);
                        });
                        _imageBlock(_image);
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            margin: EdgeInsets.all(AutoLayout.instance.pxToDp(15)),
            width: ScreenUtil().setWidth(112),
            height: AutoLayout.instance.pxToDp(112),
            child: _image == null
                ? Image.asset('images/camera_empty_icon.png')
                : Image.file(_image),
          ),
        ),
        _image != null
            ? Positioned(
                right: 0,
                child: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      _image = null;
                    });
                    _imageBlock(_image);
                  },
                  child: Container(
                    width: ScreenUtil().setWidth(30),
                    child: Image.asset(
                      'images/close.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ))
            : Container()
      ],
    );
  }
}
