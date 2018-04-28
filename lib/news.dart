import 'package:flutter/material.dart';

class News extends StatefulWidget {
  final String title,imglink;
  News(this.title,this.imglink);
  @override
  createState() => new NewsState();
}
class NewsState extends State<News> {
  @override
  Widget  build(BuildContext context){
    return new Center(
      child:new Container(
        height: 120.0,
        padding:new EdgeInsets.only(left:20.0,right:20.0),
        decoration: new BoxDecoration(
            border:new Border(
                bottom: new BorderSide(width: 1.0,color:const Color(0xff999999))
            )
        ),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Expanded(
              flex:2,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                children: <Widget>[
                  new Container(
                    padding:new EdgeInsets.only(top:15.0),
                    decoration: new BoxDecoration(
                    ),
                    child:new Text(
                      widget.title,
                      style: new TextStyle(
                          fontSize: 18.0
                      ),
                    ),
                  ),
                  new Container(
                      padding:const EdgeInsets.only(right:13.0,bottom:15.0),
                      decoration: new BoxDecoration(
                      ),
                      child:new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Text(
                            '本地新闻',
                          ),
                          new Text(
                            '2018-03-11',
                          ),
                        ],
                      )

                  ),
                ],
              ),
            ),
            new Expanded(
              flex:1,
              child: new Image.network(
                widget.imglink,
                scale: 1.0,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
