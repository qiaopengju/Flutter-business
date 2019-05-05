import 'package:flutter/material.dart';

bool darkTheme = false;
int alertNum;

alert(BuildContext context, String text){
  showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(40))
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                ListTile(
                  title: Text(text),
                ),
                Divider(),
                FlatButton(
                  child: Text('OK', style: TextStyle(color: Colors.blue),),
                  onPressed: (){Navigator.pop(context);},
                ),
              ],
            ),
          )
        );
      }
  );
}
