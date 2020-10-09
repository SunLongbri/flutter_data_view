
import 'package:flutter/material.dart';

class TabBarViewWidget extends StatelessWidget {
  final TabController tabController;
  final viewList;

  TabBarViewWidget({Key key, @required this.tabController,@required  this.viewList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: viewList,
      controller: tabController,
    );

  }
}




