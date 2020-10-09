import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';

//数据请求加载等待框
class LoadingContainer extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final bool cover;
  final double radius;
  final double marginTop;

  const LoadingContainer(
      {Key key,
      @required this.isLoading,
      this.cover = false,
      @required this.child,
      this.radius = 25.0,
      this.marginTop = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !cover
        ? isLoading ? child : _loadingView
        : Stack(
            children: <Widget>[child, isLoading ? _loadingView : Container()],
          );
  }

  Widget get _loadingView {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: AutoLayout.instance.pxToDp(marginTop)),
        child: CupertinoActivityIndicator(
          radius: radius,
          animating: isLoading,
        ),
      ),
    );
  }
}
