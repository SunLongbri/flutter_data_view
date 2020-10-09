import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BtnWidget extends StatefulWidget {
  final onTap;
  final btnContent;
  final double marginLeft;
  final double marginRignt;
  final double marginTop;
  final double marginBottom;

  const BtnWidget(
      {Key key,
        this.onTap,
        this.btnContent,
        this.marginLeft = 20,
        this.marginRignt = 20,
        this.marginTop = 0,
        this.marginBottom = 20})
      : super(key: key);

  @override
  _BtnWidgetState createState() => _BtnWidgetState();
}

class _BtnWidgetState extends State<BtnWidget> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1.0,
      child: Container(
        margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(widget.marginLeft),
          top: ScreenUtil().setWidth(widget.marginTop),
          right: ScreenUtil().setWidth(widget.marginRignt),
          bottom: ScreenUtil().setHeight(widget.marginBottom),
        ),
        child: FlatButton(
          splashColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          color: Colors.blue,
          onPressed: widget.onTap,
          child: Padding(
            padding: EdgeInsets.all(ScreenUtil().setWidth(25)),
            child: Text(
              widget.btnContent,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}