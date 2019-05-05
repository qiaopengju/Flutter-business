import 'package:sqflite/sqflite.dart';

String createTable = '''
  create table goods(
	name varchar(20),
	model varchar(20),
	primary key(name, model));

  create table replenish(
    name varchar(20),
    model varchar(20),
    num interger,
    price double,
    time date,
    finished boolean,
    primary key(name, model, time),
    foreign key(name, model) references goods(name, model));

  create table sell_record(
    name varchar(20),
    model varchar(20),
    num interger,
    price double,
    time date,
    primary key(name, model, time),
    foreign key(name, model) references goods(name, model));

  create table storehouse(
    name varchar(20),
    model varchar(20),
    num interger,
    primary key(name, model),
    foreign key(name, model) references goods(name, model));
''';
DbManager dbManager = new DbManager();
List<Map<String, dynamic>> goodsList;
List<Map<String, dynamic>> goodsStore;
List<Map<String, dynamic>> replenishList;
List<Map<String, dynamic>> sellList;

class DbManager{
  DbManager(){ openDb(); }

  var dbPath;
  String path;
  Database database;

  openDb() async {
    //dbPath = await getDatabasesPath();
    path = 'business.db';
    //path = join(dbPath, 'business.db');

    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(createTable);});
    print(database);
  }

  insertDb(String cmd) async{
    await database.transaction((txn) async{
      await txn.rawInsert(cmd);
    });
  }

  update(String cmd) async{
    await database.transaction((txn) async{
      await txn.rawUpdate(cmd);
    });
  }

  query(String cmd) async{
    //List<Map> list = await database.rawQuery(cmd);
    List<Map> list = await database.query('goods', columns: ['name', 'model']);
    return list;
  }

  delete(String cmd) async{
    await database.rawDelete(cmd);
  }
}

dbGetGoodsList([String searchText]){
  if (searchText != null){
    goodsList = dbManager.query('SELECT * FROM goods '
        'WHERE name LIKE \'%$searchText%\'');
  } else{
    goodsList = dbManager.query('SELECT * FROM goods');
  }
}

dbAddGoods(String _name, String _model){
  dbManager.insertDb('INSERT INTO goods(name, model) VALUES("$_name", "$_model")');
}