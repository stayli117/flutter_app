import 'dart:async';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/FlieDart.dart';
import 'package:flutter_app/Person.dart';
import 'package:flutter_app/Snow.dart';

void main() => runApp(new MyApp());
const platform = const MethodChannel("toast");

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Startup Name Generator',
      home: new RandomWords(),
      theme: new ThemeData(primaryColor: Colors.pink),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = new Set<WordPair>();

  final TextStyle _biggerFont = new TextStyle(fontSize: 18.0);
  int counter;
  final fileDart = new FileDart();

  @override
  void initState() {
    super.initState();
    Future<int> count = fileDart.readCounter();
    count.then((int value) {
      setState(() {
        counter = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestions(),
      floatingActionButton: new FloatingActionButton(
        onPressed: _show,
        tooltip: 'Update Text',
        child: new Icon(Icons.add),
      ),
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return new Divider();
        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          counter++;
          fileDart.incrementCounter(counter);
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      final tiles = _saved.map((pair) {
        return new ListTile(
          title: new Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
        );
      });
      final divided =
          ListTile.divideTiles(tiles: tiles, context: context).toList();
      var readCounter = fileDart.readCounter();
      readCounter.then((int value) {
        toast('总共点击' + value.toString() + '次');
      });

      toast('收藏' + divided.length.toString() + '条单词');

      return new Scaffold(
        appBar: new AppBar(
          title: new Text('saved Suggestions'),
        ),
        body: new ListView(
          children: divided,
        ),
      );
    }));
  }

  int page = 0;
  PageController pageController;
  BottomBarWidget bottomBarWidget;

  MyAppBar appBar;

  void _show() {
    toast("to user page");
    pageController = new PageController(initialPage: page);
    bottomBarWidget = new BottomBarWidget(pageController);
    appBar = new MyAppBar();
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar,
        body: new PageView(
          children: <Widget>[new Person(), new Snow()],
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: new NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: bottomBarWidget,
      );
    }));
  }

  void onPageChanged(int page) {
    setState(() {
      this.page = page;
      bottomBarWidget.onTab(page);
      appBar.onTab(page);
    });
  }
}

void toast(String msg) {
  platform.invokeMethod("short", {"message": msg});
}

class BottomBarWidget extends StatefulWidget {
  _BottomBarWidget bbw;

  BottomBarWidget(PageController pc) {
    bbw = new _BottomBarWidget(pc);
  }

  @override
  _BottomBarWidget createState() => bbw;

  void onTab(int index) {
    bbw.onTap(index);
  }
}

class _BottomBarWidget extends State<BottomBarWidget> {
  int _currentIndex = 0;
  BottomBarWidget bottomBarWidget;
  final mList = new List<BottomNavigationBarItem>();
  PageController pageController;

  _BottomBarWidget(PageController co) {
    pageController = co;
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
        items: mList, currentIndex: _currentIndex, onTap: onTap);
  }

  void onTap(int index) {
    toast(index.toString());
    setState(() {
      _currentIndex = index;
      pageController.animateToPage(index,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    });
  }

  void toast(String msg) {
    platform.invokeMethod("short", {"message": msg});
  }
}

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  _MyAppBar appBar = new _MyAppBar();

  @override
  _MyAppBar createState() => appBar;

  @override
  Size get preferredSize => appBar.preferredSize;

  void onTab(int page) {
    appBar.onTab(page);
  }
}

class _MyAppBar extends State<MyAppBar> {
  int mIn = 0;
  AppBar appBar = new AppBar(title: new Text('主页'));

  get preferredSize => appBar.preferredSize;

  @override
  Widget build(BuildContext context) {
    appBar = new AppBar(title: mIn == 0 ? new Text('主页') : new Text("雪花"));
    return appBar;
  }

  onTab(int index) {
    setState(() {
      mIn = index;
    });
  }
}

class MyPageView extends StatefulWidget {
  @override
  _MyPageView createState() => new _MyPageView();
}

class _MyPageView extends State<MyPageView> {
  @override
  Widget build(BuildContext context) {
    return new PageView.custom(childrenDelegate: null);
  }
}
