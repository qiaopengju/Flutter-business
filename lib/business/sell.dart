import 'package:flutter/material.dart';

import 'theme.dart';
import 'database.dart';
import 'function.dart';

int _selectedIndex = 0;

class Sell extends StatefulWidget{
  @override
  _SellState createState() => new _SellState();
}

class _SellState extends State<Sell>{
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
        title: new Text('Sell Management',
          style: TextStyle(
            color: mainTheme.barText,
          ),
        ),
        //centerTitle: true,
        backgroundColor: mainTheme.primarySwatch,
        elevation: 0,
      ),
      body:  _selectedIndex == 0 ? _PageAdd() : _PageRecord(),
      backgroundColor: mainTheme.primarySwatch,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle), title: Text('new bill')),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment), title: Text('sell record')),
        ],
        currentIndex: _selectedIndex,
        onTap: (index){
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class _PageRecord extends StatefulWidget{
  @override
  _PageRecordState createState() => new _PageRecordState();
}

class _PageRecordState extends State<_PageRecord>{
  List<Widget> _sellWidgetList;

  _getSellList(){
    sellList = [
      {'name': 'book', 'model': 'matrix', 'num': 12, 'price': 21,
        'time': '2019-05-01'},
    ];

    _sellWidgetList = sellList == null ? null : new List<Widget>.generate(sellList.length,
            (index){
          return Card(
            child: Stack(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.turned_in_not, color: Colors.blue),
                          title: Text(sellList[index]['name'].toUpperCase(),
                            style: TextStyle(fontSize: 20, color: Colors.blue), ),
                          subtitle: Text('--' + sellList[index]['model'],) ,
                          trailing: Text('￥' + sellList[index]['num'].toString())
                        ),
                        Divider(indent: 0,),
                        ListTile(
                          title: Row(
                            children: <Widget>[
                                  Expanded(
                                    child: Text(sellList[index]['time'], ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.fiber_manual_record, color: Colors.grey[500], size: 13,),
                                        Text('Count:  ' + sellList[index]['num'].toString()),
                                      ],
                                    )
                                  )
                            ],
                          ),
                          subtitle: Text('Total revenue: ￥' + (sellList[index]['num'] * sellList[index]['price']).toString()),
                          contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    _getSellList();

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
          children: sellList != null ? _sellWidgetList : <Widget>[
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

class _PageAdd extends StatefulWidget{
  @override
  _PageAddState createState() => new _PageAddState();
}

class _PageAddState extends State<_PageAdd>{
  //bool _shouldAdd = false;
  GlobalKey _fomrKey = new GlobalKey<FormState>();
  TextEditingController _nameCtrl = new TextEditingController(),
      _modelCtrl = new TextEditingController(),
      _numCtrl = new TextEditingController(),
      _priceCtrl = new TextEditingController(),
      _timeCtrl = new TextEditingController();
  String _name, _model, _time;
  int _count;
  double _price;

  _submitForm () async{
    if ((_fomrKey.currentState as FormState).validate()){
      /*await _alert();
      if (_shouldAdd) {*/
        _name = _nameCtrl.text;
        _model = _modelCtrl.text;
        _time = _timeCtrl.text;
        _count = int.parse(_numCtrl.text);
        _price = double.parse(_priceCtrl.text);
        //sql
        alert(context, 'Add successfully !');
      //}
    }
  }
  _alert(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            content: const Text('Add new sell record?'),
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
                        validator: (v){
                          return v.runtimeType != int ? null : 'count must be an interger';
                        },
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
                          setState(() {
                            showDatePicker(context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(DateTime.now().year - 5),
                                lastDate: DateTime(DateTime.now().year + 5)
                            ).then<void>((DateTime value){
                              _time = value.year.toString() + '-' +
                                  value.month.toString() + '-' +
                                  value.day.toString();
                            });
                            print(_time);
                          });
                        },
                        child: TextFormField(
                          enabled: false,
                          controller: _timeCtrl,
                          maxLength: 10,
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                            labelText: _time == null ? 'Bill time' : _time,
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
