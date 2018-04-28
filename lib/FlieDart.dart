import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileDart {
  /*
   * _readCounter函数，读取点击数
   * 关键字async表示异步操作
   * 返回值Future类型，表示延迟处理的对象
   */
  Future<int> readCounter() async {
    try {
      /*
       * 获取本地文件目录
       * 关键字await表示等待操作完成
       */
      File file = await _getLocalFile();
      // 使用给定的编码将整个文件内容读取为字符串
      String contents = await file.readAsString();
      // 返回文件中的点击数
      return int.parse(contents);
    } on FileSystemException {
      // 发生异常时返回默认值
      return 0;
    }
  }

// _getLocalFile函数，获取本地文件目录
  Future<File> _getLocalFile() async {
    // 获取本地文档目录
    String dir = (await getApplicationDocumentsDirectory()).path;
    // 返回本地文件目录
    return new File('$dir/counter.txt');
  }

// _incrementCounter函数，点击增加按钮时的回调
  Future<Null> incrementCounter(int counter) async {
    // 将存储点击数的变量作为字符串写入文件
    await (await _getLocalFile()).writeAsString(counter.toString());
  }
}
