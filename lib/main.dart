import 'package:flutter/material.dart';

import 'business/theme.dart';
import 'business/home.dart';
import 'business/replenish.dart';
import 'business/sell.dart';
import 'business/storehouse.dart';
import 'business/goods.dart';
import 'business/finance.dart';
import 'business/database.dart';
import 'business/function.dart';

final Map<String, WidgetBuilder> routeManager = { //路由管理
  'home': (context) => HomePage(),
  'replenish': (context) => Replenish(),
  'sell': (context) => Sell(),
  'storehouse': (context) => Storehouse(),
  'finance': (context) => Finance(),
  'goods': (context) => Goods(),
  'addGoods': (context) => AddGoodsPage(),
  'goodsList': (context) => GoodsList(),
};
GlobalKey<ScaffoldState> _mainScaffoldKey = new GlobalKey();  //用于管理主界面Scaffold状态

void main() async{
  /* 获取数据库信息 */
  await dbGetGoodsList();
  await dbGetReplenishList();
  await dbGetSellList();
  await dbGetGoodsStore();
  await dbGetSetting();
  await dbGetStoreAlerm();
  mainTheme = darkTheme ?  new MainTheme.set(ThemeColor.black) :
    new MainTheme.set(ThemeColor.blue);

  //await dbGetFinanceData(DateTime.now().day, DateTime.now().month, DateTime.now().year);

  runApp(Business()); //运行app
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

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  /*用于控制缺货预警图标颜色动画*/
  Animation<double> animation;
  AnimationController controller;

  /*初始化*/
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*初始化动画控制*/
    controller = new AnimationController(vsync: this,
        duration: const Duration(milliseconds: 3000));
    animation = new Tween(begin: 0.0, end: 255.0).animate(controller)
      ..addListener((){
        setState(() {});
      });
    controller.forward();

    /*设置监听，循环动画*/
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed){
        controller.reverse();
      } else if (status == AnimationStatus.dismissed){
        controller.forward();
      }
    });
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _mainScaffoldKey,
      appBar: new AppBar(
        leading: IconButton(icon: Icon(Icons.donut_large, //leading: 预警图标
          color: alertList.length == 0 ? mainTheme.barText :
            Color.fromARGB(255, 255, animation.value.floor(), animation.value.floor()), size: 35,),
          onPressed: (){
            if (alertList.length != 0){
              alert(context, 'Inventory shortage !');
            }
          },
        ),
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
      drawer: GestureDetector( //监听gesture
        onTapCancel: () {
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
      mainTheme.themeData = darkTheme ? ThemeColor.black : ThemeColor.blue;
      mainTheme.setThemeColor();
      dbSetTheme(darkTheme);
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

class _MainDrawer extends StatefulWidget{ //Drawer
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<_MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Setting'),
          leading: Icon(Icons.settings),
          backgroundColor: mainTheme.primarySwatch,
        ),
        body: Form( //表单
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text('Dark theme :', style: TextStyle(fontSize: 16.5, color: Colors.grey[600]),),
                trailing: Switch(value: darkTheme, onChanged: (v){ //switch开关控制是否为深色主题
                  darkTheme = v;
                }),
              ),
              Divider(color: Colors.grey[500],),
              ListTile(
                title: Text('Storage alerm num:', style: TextStyle(fontSize: 16.5, color: Colors.grey[600]),),
                trailing: Text('$alertNum'),
                subtitle: Slider(min: 5.0, max: 100.0, value: alertNum.roundToDouble(), onChanged: (v){
                  setState(() {
                    alertNum = v.floor();
                  });
                  dbSetAlertNum(alertNum);
                  dbGetStoreAlerm();
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
