/*goods添加与列举*/
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'theme.dart';
import 'database.dart';
import 'function.dart';

String _searchText, _lastSearchText; //搜索信息
enum _Operation {delete, cancel}

class Goods extends StatefulWidget{
  @override
  _GoodsState createState() => new _GoodsState();
}

class _GoodsState extends State<Goods>{
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
        //centerTitle: true,
        backgroundColor: mainTheme.primarySwatch,
        elevation: 0,
      ),
      body: new _PageBody(),
      backgroundColor: mainTheme.primarySwatch,
    );
  }
}

class _PageBody extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(30.0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.vertical(top: Radius.circular(50.0)),
        color: mainTheme.pageColor,
      ),
      constraints: BoxConstraints.expand(width: 1000.0, height: 1000.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          //children
        ],
      ),
    );
  }
}

class AddGoodsPage extends StatefulWidget{
  @override
  _AddGoodsPageState createState() => new _AddGoodsPageState();
}

class _AddGoodsPageState extends State<AddGoodsPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[900],
        title: Text('New Goods',
          style: TextStyle(fontSize: 18),),
        elevation: 5.0,
        leading: IconButton(icon: Icon(Icons.arrow_back),
            onPressed: (){Navigator.pop(context);}),
      ),
      body: new AddGoodsBody(),
    );
  }
}

class AddGoodsBody extends StatefulWidget{
  @override
  _AddGoodsBodyState createState() => new _AddGoodsBodyState();
}

class _AddGoodsBodyState extends State<AddGoodsBody>{
  //bool _shouldAdd;
  String goodsName, goodsModel; //输入表单信息，商品名称、型号
  var image; //图片文件，为FILE类型
  TextEditingController nameCtrl = new TextEditingController(); //TextForm控制
  TextEditingController modelCtrl = new TextEditingController();
  GlobalKey newGoodsKey = new GlobalKey<FormState>(); //获取表单状态
  FocusNode nameNode = new FocusNode(), modelNode = new FocusNode(); //获取焦点
  Container _choosePhotoWidget = new Container(
    padding: EdgeInsets.all(30),
    decoration: BoxDecoration(color: Colors.grey[300]),
    constraints: BoxConstraints.expand(width: 1000, height: 200),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.add_circle, size: 30, color: Colors.grey[600],),
        Text('Add photo to describe goods', style: TextStyle(color: Colors.grey[600]),),
      ],
    ),
  );

  _submitForm() async{ //提交表单
    //_shouldAdd = false;
    if ((newGoodsKey.currentState as FormState).validate()){ //如果表单验证成功
      /*给相关变量赋予表单的值*/
      goodsName = nameCtrl.text;
      goodsModel = modelCtrl.text;
      nameNode.unfocus();
      modelNode.unfocus();
      //sql
      /*先询问是否有该商品，如果商品已存在，则添加失败*/
      var _tmpGoods = await dbManager.query('goods', 'name = \'$goodsName\' AND model = \'$goodsModel\'');
      if (_tmpGoods.length != 0){
        alert(context, 'Add failed!');
      } else { //数据库中无该商品，可添加
        if (dbAddGoods(goodsName, goodsModel) != null) {
          alert(context, 'Add successfully !');
        } else {
          alert(context, 'Add failed!');
        }
      }
    }
  }
  _alert(){ //弹窗
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          content: const Text('Add this new goods?'),
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

  Future _getImage() async{ //调用imagePicker异步获取相册中的图片
    var _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = _image;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        //color: mainTheme.pageColor,
      ),
      child: SingleChildScrollView( //滚动列表，防止越界出现显示错误
        child: Form( //表单
          key: newGoodsKey,
          autovalidate: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                child: GestureDetector(
                  onTap: _getImage,
                  child: image == null ? _choosePhotoWidget : Image.file(image),
                ),
              ),
              TextFormField(
               //autofocus: true,
               maxLength: 20,
               controller: nameCtrl,
               focusNode: nameNode,
               decoration: InputDecoration(
                 labelText: 'Goods name',
                 hintText: 'Goods\'s name',
                 prefixIcon: Icon(Icons.style),
               ),
               validator: (v){ //检测表单输入
                 return v.trim().length > 0 ? null : '  Empty input';
               },
               /*onChanged: (v){
                 goodsName = v;
               },*/
             ),
             TextFormField(
               maxLength: 20,
               controller: modelCtrl,
               focusNode: modelNode,
               decoration: InputDecoration(
                 labelText: 'Goods model',
                 hintText: 'Goods\'s model',
                 prefixIcon: Icon(Icons.wrap_text)
               ),
               validator: (v){
                 return v.trim().length > 0 ? null : '  Empty input';
               },
             ),
             Container(
               margin: new EdgeInsets.fromLTRB(0, 30, 30, 30),
               child: FloatingActionButton(
                 backgroundColor: Colors.lightBlue[900],
                 child: Icon(Icons.check, color: Colors.white,),
                 onPressed: (){
                   _submitForm();
                 },
               ),
             ),
            ],
          ),
        ),
      ),
    );
  }
}

/*=============goods list================*/
class GoodsList extends StatefulWidget{ //表单列表
  @override
  _GoodsListState createState() => new _GoodsListState();
}

class _GoodsListState extends State<GoodsList>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[900],
        title: Text('Goods List',
          style: TextStyle(fontSize: 18),),
        actions: <Widget>[
          /*搜索框，通过name匹配商品，将搜索框中的值赋予_searchText*/
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
        elevation: 5.0,
        leading: IconButton(icon: Icon(Icons.arrow_back),
            onPressed: (){Navigator.pop(context);}),
      ),
      body: new GoodsListBody(),
    );
  }
}

class GoodsListBody extends StatefulWidget{
  @override
  GoodsListBodyState createState() => GoodsListBodyState();
}

class GoodsListBodyState extends State<GoodsListBody>{
  List<Widget> _listWidget;

  _getGoodsList() async{ //异步调用数据库获取商品列表
    _setWidget();

    if (_searchText == null) {
      await dbGetGoodsList();
    } else{
      await dbGetGoodsList(_searchText);
    }
    setState(() {
      _setWidget();
    });
  }

  _setWidget() { //生成列表Widget
    _listWidget = goodsList == null ? null : new List<Widget>.generate(goodsList.length,
      (int index){
        return Card(
          child: Column(
            children: <Widget>[
              new ListTile(
                title: Text(goodsList[index]['name'],
                  style: TextStyle(fontSize: 20.0),
                ),
                subtitle: Text('Model:' + goodsList[index]['model'].toString()),
                /*leading: IconButton(
                    icon: Icon(Icons.format_list_bulleted, color: Colors.blue,),
                ),*/
                leading: PopupMenuButton<_Operation>( itemBuilder: (BuildContext context) => <PopupMenuEntry<_Operation>>[
                  const PopupMenuItem(child: Text("Delete"),
                    value: _Operation.delete,
                  ),
                  const PopupMenuItem(child: Text("Cancel"),
                    value: _Operation.cancel,
                  ),
                ],
                  onSelected: (_Operation result) async{
                    if (result == _Operation.delete){
                      await dbDelGoods(goodsList[index]['name'], goodsList[index]['model']);
                    }
                    setState(() {});
                  },
                ),
              ),
              new Divider(),
            ],
          ),
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    _getGoodsList();

    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        //color: mainTheme.pageColor,
      ),
      child: ListView(
        children: goodsList != null && goodsList.length != 0 ? _listWidget:
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
