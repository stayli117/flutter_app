import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

const platform = const MethodChannel("toast");

class Person extends StatefulWidget {
  @override
  _Person createState() {
    return new _Person();
  }
}

class _Person extends State<Person> {
  List widgets = [];

  final _saved = new Set<int>();

  void initState() {
    super.initState();
    loadData();
  }

  showLoadingDialog() {
    if (widgets.length == 0) {
      return true;
    }

    return false;
  }

  getBody() {
    if (showLoadingDialog()) {
      return getProgressDialog();
    } else {
      return new ListView.builder(
          itemCount: widgets.length,
          itemBuilder: (BuildContext context, int position) {
            return buildListTile(context, position);
          });
    }
  }

  getProgressDialog() {
    return new Center(child: new CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: getBody());
  }

  loadData() async {
    String dataURL = "https://jsonplaceholder.typicode.com/posts";
    http.Response response = await http.get(dataURL);
    setState(() {
      widgets = JSON.decode(response.body);
    });
  }

  List<ListTile> wlist;
  bool enc = true;
  int ei;

  Widget buildListTile(BuildContext context, int i) {
    bool alreadySaved = _saved.contains(i);
    wlist = <ListTile>[
      new ListTile(
        selected: alreadySaved,
        isThreeLine: true,
        //子item的是否为三行
        dense: false,
        onTap: () {
          _onTap(i);
        },
        onLongPress: () {
          _onLongPress(i);
        },

        leading: new CircleAvatar(
          backgroundColor:
              (i % 2 == (enc ? 0 : 1)) ? Colors.redAccent : Colors.blueGrey,
          radius: i == ei ? 15.0 : 30.0,
          child: new Text(
            "${widgets[i]["id"]}",
            style: new TextStyle(color: alreadySaved ? Colors.white : null),
          ),
        ),
        //左侧首字母图标显示，不显示则传null
        title: new Text(
          "${widgets[i]["title"]}",
          style: new TextStyle(color: alreadySaved ? Colors.white : null),
          maxLines: 1,
        ),
        //子item的标题
        subtitle: new Text(
          "${widgets[i]["body"]}",
          style: new TextStyle(color: alreadySaved ? Colors.white : null),
          textAlign: TextAlign.justify,
        ),
        //子item的内容
        trailing: new IconButton(
          icon: new Icon(
            Icons.airport_shuttle,
            color: (i % 2 == (enc ? 0 : 1)) ? Colors.greenAccent : Colors.green,
          ),
          onPressed: () {
            setState(() {
              enc = !enc;
              ei = i;
              if (alreadySaved) {
                _saved.remove(i);
              }
              widgets.removeAt(i);
              toast('删除第' + i.toString() + '张图片');
            });
          },
        ), //显示右侧的箭头，不显示则传null
      ),
    ];

    return new Column(
      children: <Widget>[
        new Card(
          color: !alreadySaved ? Colors.white : Colors.grey,
          elevation: 1.0,
          child: new Column(
            children: wlist,
          ),
        ),
        new Divider(
          height: 2.0,
          color: Colors.blue,
        )
      ],
    );
  }

  _onTap(int i) {
//    toast(widgets[i].toString());

    showDialog<int>(
        context: context,
        barrierDismissible: false,
        child: new Center(
            child: new Card(
          color: Colors.cyanAccent,
          child: new Text(widgets[i].toString()),
        )));

  }

  void _onLongPress(int i) {
    bool alreadySaved = _saved.contains(i);
    setState(() {
      if (alreadySaved) {
        _saved.remove(i);
      } else {
        _saved.add(i);
      }
    });
  }
}

void toast(String msg) {
  platform.invokeMethod("short", {"message": msg});
}
