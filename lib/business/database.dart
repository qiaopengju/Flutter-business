/*所有数据库操作*/
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

/*建表信息*/
String createTableGoods = '''
  create table goods(
    name varchar(20),
    model varchar(20),
    primary key(name, model));
''';
String createTableReplenish = '''
  create table replenish(
    name varchar(20),
    model varchar(20),
    num interger,
    price double,
    time varchar(10),
    finished boolean,
    primary key(name, model, time),
    foreign key(name, model) references goods(name, model));
''';
String createTableSell = '''
  create table sell_record(
    name varchar(20),
    model varchar(20),
    num interger,
    price double,
    time varchar(10),
    primary key(name, model, time),
    foreign key(name, model) references goods(name, model));
''';
String createTableStorehouse = '''
  create table storehouse(
    name varchar(20),
    model varchar(20),
    num interger,
    primary key(name, model),
    foreign key(name, model) references goods(name, model));
''';
String createTableSetting = '''
  create table setting(
    single interger,
    darkTheme boolean,
    alertNum interger,
    primary key(darkTheme));
''';
DbManager dbManager = new DbManager(); //数据库管理类
List<Map<String, dynamic>> goodsList; //商品列表
List<Map<String, dynamic>> goodsStore;  //库存列表
List<Map<String, dynamic>> replenishList; //进货记录列表
List<Map<String, dynamic>> sellList;  //销售记录列表
List<Map<String, dynamic>> alertList; //缺货列表
Map<String, dynamic> financeMap = new Map<String,dynamic>(); //财政信息map
bool darkTheme; //暗色主题
int alertNum; //库存低于多少时报警

class DbManager{
  DbManager();

  static final String _databaseName = "business.db"; //数据库文件
  static final int _databaseVersion = 1; //数据库版本
  static Database _database; //静态申明数据库，临时使用
  Future<Database> get database async{ //利用getter异步获取数据库database
    if (_database != null) return _database; //如果数据库已存在，则返回
    _database = await _initDatabase(); //否则，异步初始化数据库
    return _database;
  }

  _initDatabase() async{ //生成数据库
    var documentsDirectory = await getApplicationDocumentsDirectory(); //获取应用目录
    String path = join(documentsDirectory.path, _databaseName); //添加数据库文件
    //deleteDatabase(path);
    return await openDatabase(path, version: _databaseVersion, //建立数据库
        onCreate: _onCreate); //Create时调用
  }

  Future _onCreate(Database db, int version) async{ //建立数据库时建表
    await db.execute(createTableGoods);
    await db.execute(createTableReplenish);
    await db.execute(createTableSell);
    await db.execute(createTableStorehouse);
    await db.execute(createTableSetting);
  }

  /*插入新的信息入数据库*/
  Future<int> insertDb(String table, Map<String, dynamic> row) async{
    Database _db = await database;
    return await _db.insert(table, row);
  }

  /*更新数据库信息*/
  Future<int> update(String table, Map<String, dynamic> values,
      String where) async{
    Database _db = await database;
    return await _db.update(table, values, where: where);
  }

  /*数据库查询, where 可选*/
  Future<List<Map<String, dynamic>>> query(String table,
      [String where]) async{
    Database _db = await database;

    if (where != null)
      return await _db.query(table, where: where);
    else
      return await _db.query(table);
  }

  /*较为复杂的query操作*/
  Future<List<Map<String, dynamic>>> complexQuery(String table,
  {String where, List<String> columns, String groupBy}) async{
    Database _db = await database;
    return await _db.query(table, columns: columns, where: where, groupBy: groupBy);
  }

  /*数据库删除*/
  Future<int> delete(String table, String where) async{
    Database _db = await database;
    return await _db.delete(table, where: where);
  }
}

dbGetGoodsList([String _searchText]) async{ //获取商品列表
  if (_searchText != null){ //根据搜索信息查询
    goodsList = await dbManager.query('goods', 'name LIKE \'%$_searchText%\'');
  } else{ //查询所有商品
    goodsList = await dbManager.query('goods');
  }
}

dbAddGoods(String _name, String _model) async{  //添加商品
  return await dbManager.insertDb('goods', {'name': _name, 'model': _model});
}

dbDelGoods(String _name, String _model) async{  //删除商品
  return await dbManager.delete('goods', 'name = \'$_name\' AND model = \'$_model\'');
}

dbAddReplenish(String _name, String _model, int _num, double _price, //添加进货记录
    String _time) async{
  return await dbManager.insertDb('replenish', {'name': _name, 'model': _model,
    'num': _num, 'price': _price, 'time': _time, 'finished': 0});
}

dbGetReplenishList([String _searchTime]) async{ //获取进货记录
  if (_searchTime != null){ //根据进货时间查询
    replenishList = await dbManager.query('replenish', 'time = \'$_searchTime\'');
  } else{ //查询所有进货记录
    replenishList = await dbManager.query('replenish');
  }
}

dbReplenishFinished(String _name, String _model, String _time, int _num) async{ //进货完成
  dbManager.update('replenish', {'finished': 1}, 'name = \'$_name\' '
      'AND model = \'$_model\' AND time = \'$_time\'');
  String where = 'name = \'$_name\' AND model = \'$_model\'';
  List<Map<String, dynamic>> tmpList = await dbManager.query('storehouse', where); //判断库存中是否有对应商品

  /*当进货完成时，要增加库存中的商品*/
  if (tmpList.length == 0) { //如果表中没有该商品，在库存中插入
    dbManager.insertDb('storehouse', {'name': _name, 'model': _model, 'num': _num});
  } else{ //否则，更新库存
    int tmpNum = tmpList[0]['num'];
    dbManager.update('storehouse', {'num': tmpNum + _num}, where);
  }
  dbGetStoreAlerm(); //重新获取库存预警信息
}

dbGetGoodsStore([String _searchText]) async{ //获取库存信息
  if (_searchText != null){
    goodsStore = await dbManager.query('storehouse', 'name LIKE \'%$_searchText%\'');
  } else{
    goodsStore = await dbManager.query('storehouse');
  }
}

dbGetStoreAlerm() async{ //库存预警
  alertList = await dbManager.query('storehouse', 'num < $alertNum');
}

dbAddSell(String _name, String _model, int _num, double _price, String _time) async{ //增加销售记录
  String storeWhere = 'name = \'$_name\' AND model = \'$_model\'';
  String sellWhere = 'name = \'$_name\' AND model = \'$_model\' AND time = \'$_time\'';
  List<Map<String, dynamic>> tmpStoreList = await dbManager.query('storehouse', storeWhere);
  List<Map<String, dynamic>> tmpSellList = await dbManager.query('sell_record', sellWhere);

  /*满足如下条件时，新增销售信息
  1. 库存中有此商品
  2. 库存数量大于销售数量
  */

  if (tmpStoreList.length == 0) { //如果为由库存，返回false
    return false;
  } else{
    int tmpNum = tmpStoreList[0]['num'];
    if (tmpNum < _num) return false; //如果库存小于销售量，返回false

    if (tmpNum != _num) { //更新库存
      dbManager.update('storehouse', {'num': tmpNum - _num}, storeWhere);
    } else{ //如果销售数量等于库存数量，删除该件商品
      dbManager.delete('storehouse', storeWhere);
    }
    if (tmpSellList.length == 0){ //如果没有此条销售记录，增加销售记录
      dbManager.insertDb('sell_record', {'name': _name, 'model': _model,
        'num': _num, 'price': _price, 'time': _time});
    } else{ //更新销售记录
      dbManager.update('sell_record', {'num': _num}, sellWhere);
    }
    return true;
  }
}

dbGetSellList([String _searchTime]) async{ //获取销售列表
  if (_searchTime != null){
    sellList = await dbManager.query('sell_record', 'time = \'$_searchTime\'');
  } else{
    sellList = await dbManager.query('sell_record');
  }
}

dbGetFinanceData(int _date, int _month, int _year) async{ //获取财务管理表
  List<Map<String, dynamic>> dateCount = await dbManager.complexQuery('sell_record',
    where: 'time = \'$_year-$_month-$_date\'',
    groupBy: 'time',
    columns: ['COUNT(*) AS dateDealTimes']
  );
  List<Map<String, dynamic>> dateFinance = await dbManager.complexQuery('sell_record',
    where: 'time = \'$_year-$_month-$_date\'',
    groupBy: 'time',
    columns: ['SUM(num * price) AS dateFinance']
  );
  List<Map<String, dynamic>> monthIncome = await dbManager.complexQuery('sell_record',
      where: 'time LIKE \'$_year-$_month%\'',
      columns: ['num * price AS monthIncome']
  );
  List<Map<String, dynamic>> monthExpend = await dbManager.complexQuery('replenish',
    where: 'time LIKE \'$_year-$_month%\'',
    columns: ['num * price AS monthExpend']
  );
  List<Map<String, dynamic>> yearIncome = await dbManager.complexQuery('sell_record',
      where: 'time LIKE \'$_year%\'',
      columns: ['num * price AS yearIncome']
  );
  List<Map<String, dynamic>> yearExpend = await dbManager.complexQuery('replenish',
      where: 'time LIKE \'$_year%\'',
      columns: ['num * price AS yearExpend']
  );

  if (dateCount.length != 0) {
    financeMap['dateDealTimes'] = dateCount[0]['dateDealTimes'];
  } else{
    financeMap['dateDealTimes'] = 0;
  }

  if (dateFinance.length != 0) {
    financeMap['dateFinance'] = dateFinance[0]['dateFinance'];
  } else{
    financeMap['dateFinance'] = 0.0;
  }

  if (monthIncome.length != 0){
    financeMap['monthIncome'] = monthIncome[0]['monthIncome'];
  } else{
    financeMap['monthIncome'] = 0.0;
  }

  if (monthExpend.length != 0){
    financeMap['monthExpend'] = monthExpend[0]['monthExpend'];
  } else{
    financeMap['monthExpend'] = 0.0;
  }

  if (yearIncome.length != 0){
    financeMap['yearIncome'] = yearIncome[0]['yearIncome'];
  } else{
    financeMap['yearIncome'] = 0.0;
  }

  if (yearExpend.length != 0){
    financeMap['yearExpend'] = yearExpend[0]['yearExpend'];
  } else{
    financeMap['yearExpend'] = 0.0;
  }
}

dbSetTheme(bool darkTheme) async{ //设置主题
  var tmpSetting =  await dbManager.query('setting');
  if (tmpSetting.length != 0){
    await dbManager.update('setting', {'darkTheme': darkTheme ? 1 : 0}, 'single = 0');
  } else{
    await dbManager.insertDb('setting', {'single': 0,
      'darkTheme': darkTheme ? 1 : 0, 'alertNum' : 50});
  }
}

dbSetAlertNum(int alertNum) async{ //设置预警数量
  var tmpSetting =  await dbManager.query('setting');
  if (tmpSetting.length != 0) {
    await dbManager.update('setting', {'alertNum': alertNum}, 'single = 0');
  } else{
    await dbManager.insertDb('setting', {'single': 0,
      'darkTheme': 1, 'alertNum' : alertNum});
  }
}

dbGetSetting() async{ //获取设置信息，若没有设置信息，则加入默认值
  List<Map<String, dynamic>> tmpSetting =  await dbManager.query('setting');
  if (tmpSetting.length == 0){
    await dbManager.insertDb('setting', {'single': 0,
      'darkTheme': 1, 'alertNum' : 50});
    tmpSetting =  await dbManager.query('setting');
  }
  darkTheme = tmpSetting[0]['darkTheme'] == 1;
  alertNum = tmpSetting[0]['alertNum'];
}
