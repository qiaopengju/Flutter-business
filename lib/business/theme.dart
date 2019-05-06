import 'package:flutter/material.dart';

enum ThemeColor{white, black, blue}
MainTheme mainTheme;

class MainTheme{
  MainTheme(){
    themeData = ThemeColor.white;
    setThemeColor();
  }
  MainTheme.set(this.themeData){
    setThemeColor();
  }

  ThemeColor themeData;
  Color primarySwatch;
  Color barText;
  Color pageColor;
  Color iconColor;

  void setThemeColor(){
    switch (themeData){
      case ThemeColor.blue:
        primarySwatch = Colors.blue;
        barText = Colors.white;
        pageColor = Colors.white;
        iconColor = Colors.blue[900];
        break;
      case ThemeColor.black:
        //primarySwatch = Colors.lightBlue[900];
        primarySwatch = Color.fromARGB(255, 1, 50, 89);
        barText = Colors.white;
        //pageColor = Colors.blueGrey[900];
        pageColor = Colors.black;
        iconColor = Colors.white;
        break;
      case ThemeColor.white:
        primarySwatch = Colors.white70;
        barText = Colors.black;
        pageColor = Colors.white;
        iconColor = Colors.blue[900];
        break;
    }
  }
}
// MaterialColor primarySwatch, //主题颜色样本，见下面介绍
//  Color primaryColor, //主色，决定导航栏颜色
//  Color accentColor, //次级色，决定大多数Widget的颜色，如进度条、开关等。
//  Color cardColor, //卡片颜色
//  Color dividerColor, //分割线颜色
//  ButtonThemeData buttonTheme, //按钮主题
//  Color cursorColor, //输入框光标颜色
//  Color dialogBackgroundColor,//对话框背景颜色
//  String fontFamily, //文字字体
//  TextTheme textTheme,// 字体主题，包括标题、body等文字样式
//  IconThemeData iconTheme, // Icon的默认样式
//  TargetPlatform platform, //指定平台，应用特定平台控件风格
