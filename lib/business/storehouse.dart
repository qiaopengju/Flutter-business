import 'package:flutter/material.dart';

import 'theme.dart';
import 'database.dart';

class Storehouse extends StatefulWidget{
  @override
  _StorehouseState createState() => new _StorehouseState();
}

class _StorehouseState extends State<Storehouse>{
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
        title: new Text('Storehouse',
          style: TextStyle(
            color: mainTheme.barText,
          ),
        ),
        //centerTitle: true,
        backgroundColor: mainTheme.primarySwatch,
        elevation: 0,
      ),
      body: new _PageBody(),
      backgroundColor: mainTheme.primarySwatch,
    );
  }
}

class _PageBody extends StatefulWidget{
  @override
  _PageBodyState createState() => new _PageBodyState();
}

class _PageBodyState extends State<_PageBody>{
  List<Widget> _goodsStoreList;

  _getGoodsStore(){
    goodsStore = [{'name': 'kkyou', 'model': 180, 'num': 12},
      {'name': 'simone', 'model': 160, 'num': 10},
    ];
    _goodsStoreList = goodsStore == null ? null : new List<Widget>.generate(goodsStore.length,
      (index){
        return Card(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(goodsStore[index]['name'] + '--' +
                    goodsStore[index]['model'].toString(),
                  style: TextStyle(fontSize: 20.0),
                ),
                subtitle: Text('remainder:' + goodsStore[index]['num'].toString()),
                leading: Icon(Icons.panorama_fish_eye, color: Colors.blue,),
              ),
              new Divider(),
            ],
          ),
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    _getGoodsStore();

    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.vertical(top: Radius.circular(50.0)),
        color: mainTheme.pageColor,
      ),
      constraints: BoxConstraints.expand(width: 1000.0, height: 1000.0),
      child: ListView(
        /*mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,*/
        children: goodsStore != null ? _goodsStoreList :
        <Widget> [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.toc, size: 100, color: Colors.grey[200],),
              Text('null', style: TextStyle(color: Colors.grey[200], fontSize: 25),)
            ],
          )
        ],
      ),
    );
  }
}

