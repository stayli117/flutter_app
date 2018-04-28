import 'package:flutter/material.dart';

class BottomBarWidget extends StatefulWidget {
  _BottomBarWidget bbw;

  BottomBarWidget({Key key}) : super(key: key) {
    bbw = new _BottomBarWidget();
  }

  @override
  _BottomBarWidget createState() => bbw;
}

class _BottomBarWidget extends State<BottomBarWidget> {
  int _currentIndex = 0;

  BottomBarWidget bottomBarWidget;
  final mList = new List<BottomNavigationBarItem>();

  _BottomBarWidget() {
    final bar = new BottomNavigationBarItem(
        icon: new Icon(Icons.account_circle), title: new Text("主页"));
    final bar1 = new BottomNavigationBarItem(
        icon: new Icon(Icons.ac_unit), title: new Text("雪花"));
    mList.add(bar);
    mList.add(bar1);
  }

  @override
  Widget build(BuildContext context) {
    return new BottomNavigationBar(
        items: mList,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        });
  }
}
