/*财务管理*/
import 'package:flutter/material.dart';

import 'theme.dart';
import 'database.dart';

int _dateDealTimes;
int _date, _month, _year;
double _dateFinance, _monthIncome, _monthExpend, _yearIncome, _yearExpend;

class Finance extends StatefulWidget{
  @override
  _FinanceState createState() => new _FinanceState();
}

class _FinanceState extends State<Finance>{
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
        title: new Text('Finance Management',
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
  Widget dayFinanceWidget, monthFinanceWidget, yearFinanceWidget;
  final List<int> _monthDateEnum = List<int>.generate(31,
    (index){
      return index + 1;
    }
  );

  _PageBodyState() {
    _initialFinance(DateTime.now().day, DateTime.now().month, DateTime.now().year);
  }


  _initialFinance(int date, int month, int year) async{ //设置并从数据库异步获取财务信息
    _date = date;
    _month = month;
    _year = year;

    await dbGetFinanceData(_date, _month, _year); //从数据库异步获取财务信息
    print(financeMap);

    _dateDealTimes = financeMap['dateDealTimes'];
    _dateFinance = financeMap['dateFinance'];
    _monthIncome = financeMap['monthIncome'];
    _monthExpend = financeMap['monthExpend'];
    _yearIncome = financeMap['yearIncome'];
    _yearExpend = financeMap['yearExpend'];

    setState(() {
      _setWidget(); //设置财务信息Widget
    });
  }

  _setWidget(){
    dayFinanceWidget = new Card( //日财务统计Widget
      margin: EdgeInsets.all(10),
      elevation: 5,
      child: Padding(
          padding: EdgeInsets.fromLTRB(5, 5, 5, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ListTile(
              title: Text('$_month.$_date 收款记录',
                style: TextStyle(fontSize: 18, color: Colors.blue),
                textAlign: TextAlign.left,),
              leading: Icon(Icons.attach_money, color: Colors.blue,),
            ),
            Divider(color: Colors.black45,),
            ListTile(
              title: Text('当日收款',
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
              subtitle: Text('￥$_dateFinance',
                style: TextStyle(),
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text('交易次数',
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      Text('$_dateDealTimes',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                   children: <Widget>[
                     Text('单笔均价',
                       style: TextStyle(fontSize: 14),
                     ),
                     Text('￥${_dateDealTimes == 0.0 ? 0.0 :
                      _dateFinance / _dateDealTimes}',
                      style: TextStyle(color: Colors.grey[600])
                     ),
                   ],
                  ),
                ),
              ],
            ),
            Divider(color: Colors.black45,),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 250),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text('日期 : ',
                        style: TextStyle(color: Colors.lightBlue[600]),),
                      DropdownButton(
                          items: _monthDateEnum.map<DropdownMenuItem<int>>((int value){
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString(), style: TextStyle(fontSize: 15,
                                color: Colors.lightBlue[600]),),
                            );
                          }).toList(),
                          value: _date,
                          onChanged: (int v){
                            setState(() {
                              _date = v;
                              _initialFinance(_date, _month, _year);
                            });
                          }
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    monthFinanceWidget = new Card( //月财务统计Widget
      margin: EdgeInsets.all(10),
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.fromLTRB(5, 5, 5, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ListTile(
              title: Text('$_month月实时账单',
                style: TextStyle(fontSize: 18, color: Colors.blue),
                textAlign: TextAlign.left,),
              leading: Icon(Icons.format_list_numbered, color: Colors.blue,),
            ),
            Divider(color: Colors.black45,),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      //gradient: RadialGradient(colors: [Colors.lightBlue[600], Colors.lightBlue[200]],),
                      border: Border.all(color: Colors.cyan[100], width: 5, style: BorderStyle.solid),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Text('月收益',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text('￥${_monthIncome - _monthExpend}',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: <Widget>[
                      Text('总支出',
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      Text('￥$_monthExpend',
                        style: TextStyle(color: Colors.red[200]),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: <Widget>[
                      Text('总收入',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text('￥$_monthIncome',
                          style: TextStyle(color: Colors.grey[600])
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(color: Colors.black45,),
            FlatButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  /*Text('查看详情',
                    style: TextStyle(color: Colors.lightBlue[600]),),
                  Icon(Icons.call_missed_outgoing, color: Colors.lightBlue[600],)*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
    yearFinanceWidget = new Card( //年财务统计Widget
      margin: EdgeInsets.all(10),
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.fromLTRB(5, 5, 5, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ListTile(
              title: Text('$_year年账单',
                style: TextStyle(fontSize: 18, color: Colors.blue),
                textAlign: TextAlign.left,),
              leading: Icon(Icons.show_chart, color: Colors.blue,),
            ),
            Divider(color: Colors.black45,),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.cyan[100]
                    ),
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: <Widget>[
                        Text('年收益',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text('￥${_yearIncome - _yearExpend}',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: <Widget>[
                      Text('总支出',
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      Text('￥$_yearExpend',
                        style: TextStyle(color: Colors.red[200]),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: <Widget>[
                      Text('总收入',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text('￥$_yearIncome',
                          style: TextStyle(color: Colors.grey[600])
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(color: Colors.black45,),
            FlatButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  /*Text('查看详情',
                    style: TextStyle(color: Colors.lightBlue[600]),),
                  Icon(Icons.call_missed_outgoing, color: Colors.lightBlue[600],)*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(5.0),
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
            Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                children: <Widget>[
                  dayFinanceWidget,
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: monthFinanceWidget,
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: yearFinanceWidget,
            ),
            //children
          ],
        ),
      ),
    );
  }
}
