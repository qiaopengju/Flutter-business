/*进货管理，包括进货记录添加，进货记录查询*/
import 'package:flutter/material.dart';

import 'theme.dart';
import 'database.dart';
import 'function.dart';

int _selectedIndex = 0; //页面号
String _searchText; //进货记录查询String

class Replenish extends StatefulWidget{
  @override
  _ReplenishState createState() => new _ReplenishState();
}

class _ReplenishState extends State<Replenish>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        leading: IconButton(
            icon: Icon(Icons.undo, color: mainTheme.barText,),
            onPressed: (){
              Navigator.pop(context);
            },
        ),
        title: new Text('Replenish',
          style: TextStyle(
            color: mainTheme.barText,
          ),
        ),
        /*设置一个time picker用于获取搜索时间*/
        actions: <Widget>[
          _selectedIndex == 0 ? Column() :
          FlatButton(
            padding: EdgeInsets.all(0),
            onPressed:() {
              showDatePicker(context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(DateTime.now().year - 5),
                  lastDate: DateTime(DateTime.now().year + 5)
              ).then<void>((DateTime value) {
                _searchText = value.year.toString() + '-' +
                    value.month.toString() + '-' +
                    value.day.toString();
                setState(() {});
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FlatButton(
                  child: Row(
                    children: <Widget>[
                      Text(_searchText == null ? 'All times': _searchText, style: TextStyle(color: Colors.grey[300]),),
                     _searchText == null ? Column() : Icon(Icons.close, size: 12, color: Colors.grey[300],),
                    ],
                  ),
                  onPressed: (){
                    setState(() { _searchText = null; });
                  },
                ),
                FlatButton(child: Icon(Icons.search, color: Colors.white,)),
              ],
            ),
          ),
        ],
        //centerTitle: true,
        backgroundColor: mainTheme.primarySwatch,
        elevation: 0,
      ),
      body: _selectedIndex == 0 ? _PageAdd() : _PageRecord(), //根据不同的页面号加载不同的页面
      backgroundColor: mainTheme.primarySwatch, //主题颜色
      bottomNavigationBar: BottomNavigationBar( //底部菜单
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle), title: Text('new record')),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment), title: Text('replenish record')),
        ],
        currentIndex: _selectedIndex,
        onTap: (index){
          setState(() {
            _selectedIndex = index; //更换页面索引
          });
        },
      )
    );
  }
}

class _PageRecord extends StatefulWidget{ //进货记录列表
  @override
  _PageRecordState createState() => new _PageRecordState();
}

class _PageRecordState extends State<_PageRecord>{
  List<Widget> _replenishWidgetList; //进货记录Widget
  Color _usefulColor = Colors.blue; //正在进货的颜色
  Color _uselessColor = Colors.grey; //进货完成的颜色

  _getReplenishList() async{ //异步从数据库获取进货记录
    _setWidget();
    if (_searchText == null) { //如果有搜索项，则按时间搜索进货信息
      await dbGetReplenishList();
    } else{
      await dbGetReplenishList(_searchText);
    }

    setState(() {
      _setWidget(); //设置进货记录列表Widget
    });
  }

  _setWidget(){
    _replenishWidgetList = replenishList == null ? null : new List<Widget>.generate(replenishList.length,
      (index){
        return GestureDetector(
          onTap: (){
            if (replenishList[index]['finished'] == 0) {
              print(replenishList[index]);
              dbReplenishFinished(replenishList[index]['name'],
                replenishList[index]['model'], replenishList[index]['time'],
                replenishList[index]['num']);
              dbGetReplenishList();
              setState(() {});
            }
          },
          child: Card(
            child: Stack(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    replenishList[index]['finished'] == 0 ? Text(''):
                    Positioned(
                      top: 110,
                      left: 270,
                      child: Transform(
                        alignment: Alignment.topRight,
                        transform: new Matrix4.skewY(-0.3),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 5, style: BorderStyle.solid, color: Colors.grey[300]),
                            shape: BoxShape.circle,
                          ),
                          child: Column(
                            children: <Widget>[
                              Text('Finished'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        ListTile(
                          leading: replenishList[index]['finished'] == 1 ?
                            Icon(Icons.turned_in, color: replenishList[index]['finished'] == 1? _uselessColor : _usefulColor,) :
                            Icon(Icons.turned_in_not, color: replenishList[index]['finished'] == 1 ? _uselessColor : _usefulColor),
                          //),
                          title: Text(replenishList[index]['name'].toUpperCase(),
                            style: TextStyle(fontSize: 20, color:
                            replenishList[index]['finished'] == 1 ? _uselessColor : _usefulColor),),
                          subtitle: Text('--' + replenishList[index]['model'],) ,
                          trailing: Text('￥' + replenishList[index]['num'].toString()),
                        ),
                        Divider(indent: 0,),
                        ListTile(
                          title: Row(
                            children: <Widget>[
                              Text(replenishList[index]['time'], ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(Icons.fiber_manual_record, color: Colors.grey[500], size: 13,),
                                  Text('Count:  ' + replenishList[index]['num'].toString()),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.fiber_manual_record, color: Colors.grey[500], size: 13,),
                                  Text('State:    ' + (replenishList[index]['finished'] == 1 ? 'finished' : 'replenishing')),
                                ],
                              ),
                            ],
                          ),
                          contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    _getReplenishList();

    // TODO: implement build
    return Container(
      padding: EdgeInsets.fromLTRB(30.0, 10, 30, 0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.vertical(top: Radius.circular(50.0)),
        color: mainTheme.themeData == ThemeColor.blue ? Colors.grey[100]: Colors.grey[300],
      ),
      constraints: BoxConstraints.expand(width: 1000.0, height: 1000.0),
      child: SingleChildScrollView(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: replenishList != null && replenishList.length != 0 ? _replenishWidgetList : <Widget>[
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.toc, size: 100, color: Colors.grey[200],),
              Text('null', style: TextStyle(color: Colors.grey[200], fontSize: 25),)
            ],
          )
          //children
        ],
        ),
      ),
    );
  }
}

class _PageAdd extends StatefulWidget{ //新增进货记录
  @override
  _PageAddState createState() => new _PageAddState();
}

class _PageAddState extends State<_PageAdd>{
  //bool _shouldAdd = false;
  GlobalKey _fomrKey = new GlobalKey<FormState>(); //获取表单状态
  TextEditingController _nameCtrl = new TextEditingController(), //文本框控制
    _modelCtrl = new TextEditingController(),
    _numCtrl = new TextEditingController(),
    _priceCtrl = new TextEditingController(),
    _timeCtrl = new TextEditingController();
  /*输入的商品信息*/
  String _name, _model, _time;
  int _count;
  double _price;

  _submitForm () async{ //异步提交表单至数据库
    if ((_fomrKey.currentState as FormState).validate()){ //检测表单正确
      /*将表单赋值*/
      _name = _nameCtrl.text;
      _model = _modelCtrl.text;
      _count = int.parse(_numCtrl.text);
      _price = double.parse(_priceCtrl.text);

      if (_time != null){
        var _tmpReplenish = await dbManager.query('replenish', 'name = \'$_name\' AND '
            'model = \'$_model\' AND time = \'$_time\'');
        var _tmpGoods = await dbManager.query('goods', 'name = \'$_name\' AND model = \'$_model\'');

        if (_tmpReplenish.length != 0 || _tmpGoods.length == 0){ //如果销售记录已存在或不存在该商品，报错
          alert(context, 'Add failed!');
        } else { //如果销售记录不存在，添加
          if (dbAddReplenish(_name, _model, _count, _price, _time) != null) {
            alert(context, 'Add successfully !');
          } else {
            alert(context, 'Add failed!');
          }
        }
      } else{ //未选择时间，报错
        alert(context, 'Please select time!');
      }
    }
  }
  _alert(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            content: const Text('Add new replenish record?'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    //_shouldAdd = true;
                    Navigator.pop(context);
                  },
                  child: const Text('YES')
              ),
              FlatButton(
                  onPressed: () {
                    //_shouldAdd = false;
                    Navigator.pop(context);
                  },
                  child: const Text('CANCEL')
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.vertical(top: Radius.circular(50.0)),
        color: mainTheme.themeData == ThemeColor.blue ? Colors.grey[100]: Colors.grey[300],
      ),
      constraints: BoxConstraints.expand(width: 1000.0, height: 1000.0),
      child: SingleChildScrollView(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              color: Colors.white,
            ),
            child: Form(
              key: _fomrKey,
              autovalidate: true,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _nameCtrl,
                    maxLength: 20,
                    decoration: InputDecoration(
                      labelText: 'Goods\'s name',
                      hintText: 'Name',
                      prefixIcon: Icon(Icons.style),
                    ),
                    validator: (v){
                      return v.trim().length > 0 ? null : 'empty input';
                    },
                  ),
                  TextFormField(
                    controller: _modelCtrl,
                    maxLength: 20,
                    decoration: InputDecoration(
                      labelText: 'Goods\' s model',
                      hintText: 'Model',
                      prefixIcon: Icon(Icons.wrap_text)
                    ),
                    validator: (v){
                      return v.trim().length > 0 ? null : 'empty input';
                    },
                  ),
                  TextFormField(
                    controller: _numCtrl,
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Count',
                      hintText: 'Count',
                      prefixIcon: Icon(Icons.filter_list),
                    ),
                  ),
                  TextFormField(
                    controller: _priceCtrl,
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Price',
                      hintText: 'Price',
                      prefixIcon: Icon(Icons.monetization_on),
                    ),
                  ),
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    onPressed:() {
                        showDatePicker(context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(DateTime.now().year - 5),
                            lastDate: DateTime(DateTime.now().year + 5)
                        ).then<void>((DateTime value) {
                          _time = value.year.toString() + '-' +
                              value.month.toString() + '-' +
                              value.day.toString();
                          setState(() {});
                        });
                    },
                    child: TextFormField(
                      controller: _timeCtrl,
                      enabled: false,
                      maxLength: 10,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        labelText: _time == null ? 'Replenish time' : _time,
                        hintText: 'yyyy-mm-dd',
                        prefixIcon: Icon(Icons.timer),
                      ),
                    ),
                  ),
                  OutlineButton(
                    padding: EdgeInsets.only(left: 70, right: 70),
                    child: Text('Submit', style: TextStyle(color: Colors.blue),),
                    onPressed: _submitForm,
                  ),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
