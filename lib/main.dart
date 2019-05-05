import 'package:flutter/material.dart';

import 'business/theme.dart';
import 'business/home.dart';
import 'business/replenish.dart';
import 'business/sell.dart';
import 'business/storehouse.dart';
import 'business/goods.dart';
import 'business/finance.dart';
import 'business/function.dart';

final Map<String, WidgetBuilder> routeManager = {
  'home': (context) => HomePage(),
  'replenish': (context) => Replenish(),
  'sell': (context) => Sell(),
  'storehouse': (context) => Storehouse(),
  'finance': (context) => Finance(),
  'goods': (context) => Goods(),
  'addGoods': (context) => AddGoodsPage(),
  'goodsList': (context) => GoodsList(),
};
GlobalKey<ScaffoldState> _mainScaffoldKey = new GlobalKey();

void main(){
  runApp(Business());
}

class Business extends StatefulWidget{
  @override
  _BusinessState createState() => new _BusinessState();
}

class _BusinessState extends State<Business>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: new HomePage(),
      routes: routeManager,
    );
  }
}

class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage>{
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _mainScaffoldKey,
      appBar: new AppBar(
        leading: Icon(Icons.donut_large, color: mainTheme.barText, size: 35,),
        title: new Text('Business',
          style: TextStyle(
            color: mainTheme.barText,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list, color: Colors.white, size: 30,),
            onPressed: (){
              _mainScaffoldKey.currentState.openDrawer();
            },
          )
        ],
        backgroundColor: mainTheme.primarySwatch,
        elevation: 0,
      ),
      drawer: GestureDetector(
        onTap: (){
          setState(() {
            themeButtonPressed();
          });
        },
        child: _MainDrawer(),
      ),
      body: new HomeBody(),
      backgroundColor: mainTheme.primarySwatch,
    );
    //return new PageTemplate(leadingPressed: themeButtonPressed, ).page;
  }

  themeButtonPressed(){
    setState(() {
      //mainTheme.themeData = mainTheme.themeData == ThemeColor.blue ? ThemeColor.black : ThemeColor.blue;
      mainTheme.themeData = darkTheme ? ThemeColor.black : ThemeColor.blue;
      mainTheme.setThemeColor();
    });
  }
}

class HomeBody extends StatelessWidget{
  FuncIconList list = new FuncIconList();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      //padding: EdgeInsets.fromLTRB(0, 0, 0, 30.0),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: new BorderRadius.vertical(top: Radius.circular(50.0)),
          color: mainTheme.pageColor,
      ),
      constraints: BoxConstraints.expand(width: 1000.0, height: 1000.0),
      child: SingleChildScrollView(
        child: Column( //function icon
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Expanded(
                  child: FlatButton(//replenish
                    child: list.funcIcon[0], //replenish
                    onPressed: (){Navigator.pushNamed(context, 'replenish');},
                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50.0))),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(50.0))),
                  ),
              ),
              new Expanded(
                  child: FlatButton(//sell
                    child: list.funcIcon[1],
                    onPressed: (){Navigator.pushNamed(context, 'sell');},
                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50.0))),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(50.0))),
                  ),
              ),
            ],
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Expanded(
                child: FlatButton(//replenish
                  child: list.funcIcon[2], //replenish
                  onPressed: (){Navigator.pushNamed(context, 'storehouse');},
                  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50.0))),
                ),
              ),
              new Expanded(
                child: FlatButton(//sell
                  child: list.funcIcon[3],
                  onPressed: (){Navigator.pushNamed(context, 'finance');},
                  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50.0))),
                ),
              ),
            ],
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Expanded(
                child: FlatButton(//replenish
                  child: list.funcIcon[4], //replenish
                  onPressed: (){Navigator.pushNamed(context, 'addGoods');},
                  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50.0))),
                ),
              ),
              new Expanded(
                child: FlatButton(//replenish
                  child: list.funcIcon[5], //replenish
                  onPressed: (){Navigator.pushNamed(context, 'goodsList');},
                  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50.0))),
                ),
              ),
            ],
          ),
        ],),
      ),
    );
  }
}
class _MainDrawer extends StatefulWidget{
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<_MainDrawer>{
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Setting'),
          leading: Icon(Icons.settings),
          backgroundColor: mainTheme.primarySwatch,
        ),
        body: Form(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text('Dark theme:', style: TextStyle(fontSize: 16.5, color: Colors.grey[600]),),
                trailing: Switch(value: darkTheme, onChanged: (v){
                  darkTheme = v;
                }),
              ),
              Divider(color: Colors.grey[500],),
            ],
          ),
        ),
      ),
    );
  }
}
