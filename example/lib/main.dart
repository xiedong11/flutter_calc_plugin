import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_calc_plugin/flutter_calc_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String addResult = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> getAddResult(int a, int b) async {
    String result = '';
    try {
      result = await FlutterCalcPlugin.getResult(a, b);
    } on PlatformException {
      result = '未知错误';
    }
    setState(() {
      addResult = result;
    });
  }

  Future<void> initPlatformState() async {
    String platformVersion;

    try {
      platformVersion = await FlutterCalcPlugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('插件示例'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              color: Colors.amber,
              child: Text("获取系统版本"),
              onPressed: () {
                initPlatformState();
              },
            ),
            Text('当前系统版本 : $_platformVersion\n'),
            SizedBox(height: 30),
            Text("计算 36+25=？"),
            MaterialButton(
              color: Colors.amber,
              child: Text("结果等于"),
              onPressed: () {
                getAddResult(36, 25);
              },
            ),
            Text(addResult),
          ],
        )),
      ),
    );
  }
}
