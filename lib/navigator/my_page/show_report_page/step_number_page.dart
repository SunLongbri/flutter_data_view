import 'package:flutter/material.dart';
import 'package:fluttermarketingplus/model/stepNumberData.dart';

//小哥步行排名
class StepNumberPage extends StatefulWidget {
  final List<String> stepNumberList;

  const StepNumberPage({Key key, this.stepNumberList}) : super(key: key);

  @override
  _StepNumberPageState createState() => _StepNumberPageState();
}

class _StepNumberPageState extends State<StepNumberPage> {
  List<String> stepList;

  @override
  void initState() {
    print('接受到的数据为:${widget.stepNumberList}');
    stepList = widget.stepNumberList;
    for (String step in stepList) {
      print('step:${step}');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      //头部背景图片
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/RankingBackground.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            //标题及返回
            Container(
              height: 44,
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(right: 44),
                    child: Text(
                      '小哥步数排行',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  )),
                ],
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            //头像图片
            ClipOval(
                child: Image(
              width: 50.0,
              height: 50.0,
              image: NetworkImage(
                  'https://dss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3293144012,2335984271&fm=26&gp=0.jpg'),
              fit: BoxFit.fitHeight,
            )),
            SizedBox(
              height: 15.0,
            ),
            //名称 步数
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    '美女',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBox(width: 20.0),
                Container(
                  width: 0.7,
                  height: 15.0,
                  color: Colors.white,
                ),
                SizedBox(width: 20.0),
                Expanded(
                  child: Text(
                    '9999步',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Expanded(
              //列表
              child: Container(
                //设置四周圆角 角度
                // borderRadius: BorderRadius.only(
                //   bottomLeft: Radius.circular(5.0),
                //   bottomRight: Radius.circular(5.0)
                // ),
                margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: _listViewBuilder(),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  //列表控件
  Widget _listViewBuilder() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        //圆角
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: ListView.builder(
        itemCount: steps.length,
        itemBuilder: _listItemBuilder,
      ),
    );
  }

//列表 cell
  Widget _listItemBuilder(BuildContext context, int index) {
    Widget _rangingWidge;
    if (index == 0) {
      _rangingWidge = Container(
        child: Image(
            image: AssetImage('images/first.png'),
            alignment: Alignment.centerLeft),
      );
      //
    } else if (index == 1) {
      _rangingWidge = Container(
        child: Image(
            image: AssetImage('images/Second.png'),
            alignment: Alignment.centerLeft),
      );
    } else if (index == 2) {
      _rangingWidge = Container(
        child: Image(
            image: AssetImage('images/Third.png'),
            alignment: Alignment.centerLeft),
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      );
    } else {
      _rangingWidge = Container(
        child: Text(steps[index].ranking, textAlign: TextAlign.left),
        margin: EdgeInsets.fromLTRB(7, 0, 0, 0),
      );
    }
    return Container(
      margin: EdgeInsets.fromLTRB(16, 10, 16, 6),
      padding: EdgeInsets.only(top: 5.0),
      child: Row(
        children: <Widget>[
          //排名
          Expanded(
            child: _rangingWidge,
          ),
          //头像
          ClipOval(
              child: Image.network(
            steps[index].imageUrl,
            width: 30.0,
            height: 30.0,
            fit: BoxFit.cover,
          )),
          SizedBox(
            width: 10.0,
          ),
          //名称
          Expanded(
              flex: 3,
              child: Text(
                steps[index].name,
                style: TextStyle(color: Colors.blue),
              )),
          //步数
          Expanded(
              flex: 2,
              child: Text(
                steps[index].stepNumber + '步',
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.blue),
              )),
        ],
      ),
    );
  }
}
