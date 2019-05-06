import 'package:flutter/material.dart';

import 'theme.dart';
import 'database.dart';
import 'function.dart';

String _searchText, _lastSearchText;

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
        actions: <Widget>[
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search),
            onPressed: () async {
              _searchText = await showSearch<String>(
                context: context,
                delegate: SearchStringDelegate(),
              );
              if (_searchText != null && _searchText != _lastSearchText) {
                setState(() {
                  _lastSearchText = _searchText;
                });
              }
            },
          ),
        ],
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

  _getGoodsStore() async{
    _setWidget();
    if (_searchText == null) {
      await dbGetGoodsStore();
    }else{
      await dbGetGoodsStore(_searchText);
    }

    setState(() {
      _setWidget();
    });
  }

  _setWidget(){
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
        children: goodsStore != null && goodsStore.length != 0 ? _goodsStoreList :
        <Widget> [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.toc, size: 100, color: Colors.grey[200],),
              Text('null', style: TextStyle(color: Colors.grey[200], fontSize: 25),),
            ],
          )
        ],
      ),
    );
  }
}

