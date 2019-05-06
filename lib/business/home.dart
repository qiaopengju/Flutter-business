/*用于存放主页图标信息*/
import 'package:flutter/material.dart';
import 'theme.dart';

class FuncIconCards{
  List<FuncIcon> funIconCards = [
    new FuncIcon(
      Text('Replenish',
        style: TextStyle(color: mainTheme.iconColor, fontSize: 14),
      ),
      IconButton(
        icon: Icon(
          Icons.local_shipping,
          color: mainTheme.iconColor,
        ),
        iconSize: 60,
      ),
    ),
    new FuncIcon(
      Text('Sell Manager',
        style: TextStyle(color: mainTheme.iconColor, fontSize: 14),
      ),
      IconButton(
        icon: Icon(
          Icons.donut_small,
          color: mainTheme.iconColor,
        ),
        iconSize: 60,
      ),
    ),
    new FuncIcon(
      Text('Storehouse',
        style: TextStyle(color: mainTheme.iconColor, fontSize: 14),
      ),
      IconButton(
        icon: Icon(
          Icons.store,
          color: mainTheme.iconColor,
        ),
        iconSize: 60,
      ),
    ),
    new FuncIcon(
      Text('Finance',
        style: TextStyle(color: mainTheme.iconColor, fontSize: 14),
      ),
      IconButton(
        icon: Icon(
          Icons.attach_money,
          color: mainTheme.iconColor,
        ),
        iconSize: 60,
      ),
    ),
    new FuncIcon(
      Text('Add new Goods',
        style: TextStyle(color: mainTheme.iconColor, fontSize: 14),
      ),
      IconButton(
        icon: Icon(
          Icons.add,
          color: mainTheme.iconColor,
        ),
        iconSize: 60,
      ),
    ),
    new FuncIcon(
      Text('Goods list',
        style: TextStyle(color: mainTheme.iconColor, fontSize: 14),
      ),
      IconButton(
        icon: Icon(
          Icons.sort,
          color: mainTheme.iconColor,
        ),
        iconSize: 60,
      ),
    ),
  ];
}

class FuncIcon{
  FuncIcon(this.text, this.icon);

  Text text;
  IconButton icon;
}

class FuncIconList{ //生成图标列表
  List<Column> funcIcon = new List<Column>.generate(/*funIconCards.length*/6,
          (int index){
        FuncIconCards cards = new FuncIconCards();
        bool odd = (index + 1) % 2 == 1;

        return Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              margin: new EdgeInsets.only(top: 40.0),
              padding: new EdgeInsets.only(left: odd ? 30: 20, right: odd ? 20.0 : 30),
              child: cards.funIconCards[index].icon,
            ),
            Container(
              margin: new EdgeInsets.only(top: 20, bottom: 20),
              padding: new EdgeInsets.only(left: odd ? 30: 20, right: odd ? 20.0 : 30),
              child: cards.funIconCards[index].text,
            ),
          ],
        );
      }
  );
}
