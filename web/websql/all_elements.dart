library testwebsql;

import 'package:polymer/polymer.dart';
//import 'dart:indexed_db' as idb;
import 'dart:web_sql';
//import 'dart:web_sql';
import 'dart:html';
import 'dart:async';

class MyModel extends Object with Observable{
  @observable String foo;
  String toString(){
    return "MyModel[foo:$foo]";
  }
}
//import '../../lib/dartattemptslib.dart';

class ListItem extends Object with Observable{
  @observable bool selected;
  @observable MyModel item;
  ListItem(this.item, [this.selected = false]);

  String toString(){
    return {
      'selected' : selected,
      'item':item
    }.toString();
  }
}



@CustomTag('my-idblist')
class MyList extends PolymerElement {
  //@observable MyModel model = new MyModel();
  List<ListItem> items = toObservable(new List());
  //Store store;
  static const DBNAME = "testdb";
  static const STORENAME = "teststore";
  static const INDEXNAME = "indexfield";

  static const TXN_RW = "readwrite";
  static const TXN_RO = "readonly";

  final List<IndexDesc> indexes = [new IndexDesc(INDEXNAME, INDEXNAME)];
//  idb.Database _db;

  MyList.created() : super.created(){

//    initDB().then((db){
//      _db = db;
//      //clear
//      var trans = db.transaction(STORENAME, TXN_RW);
//      var store = trans.objectStore(STORENAME);
//      store.clear();
//      return trans.completed;
//    }).then((db){
//      //insert
//      var trans = db.transaction(STORENAME, TXN_RW);
//      var store = trans.objectStore(STORENAME);
//      store.put({INDEXNAME:"prvy"}, "1");
//      store.put({INDEXNAME:"druhy"}, "2");
//      store.put({INDEXNAME:"treti"}, "3");
//      store.put({INDEXNAME:"stvrty"}, "4");
//      return trans.completed;
//    }).then((_){
//      load();
//    });


//    store = new Store('testdb', 'hello', indexes: [new IndexDesc("name", "name")] );
//    store.open().then((_){
//      return store.nuke();
//    }).then((_){
//      return store.save({"name":"prvy"}, "prvy");
//    }).then((_){
//      return store.save({"name":"druhy"}, "druhy");
//    }).then((_){
//      return store.save({"name":"treti"}, "treti");
//    }).then((_){
//      return store.save({"name":"stvrty"}, "stvrty");
//    }).then((_){
//      load();
//    });
  }

  void ready(){
    super.ready();
    initDB().then((SqlDatabase db){
      var upsertSql = 'INSERT OR REPLACE INTO $STORENAME (id, value) VALUES (?,?)';
      db.transaction((txn) {
        txn.executeSql(upsertSql, ['first', 'first value'], (txn, resultSet) {
          log('insert done');
        });
      });
    });
  }
  void load(){
    items.clear();

//    var trans = _db.transaction(STORENAME, TXN_RO);
//    var store = trans.objectStore(STORENAME);
//    var index = store.index(INDEXNAME);
//
//    var range = new idb.KeyRange.bound("a","pr"+'\uffff');
//    index.openCursor(range: range, autoAdvance: true).listen((cursor){
//      var map = cursor.value;
//      items.add(new ListItem(new MyModel()..foo=map[INDEXNAME]));
//    });

//    store.allByIndex("name", only:"druhy").listen((map){
//      items.add(new ListItem(new MyModel()..foo=map["name"]));
//    });
  }
  Future<SqlDatabase> initDB(){
    var c = new Completer<SqlDatabase>();

    SqlDatabase db = window.openDatabase(DBNAME, "1", DBNAME, 4*1024, (SqlDatabase db){
      log('database opened');
    });
    db = window.openDatabase(DBNAME, "1", DBNAME, 40*1024*1024, (SqlDatabase db){
      log('database opened 2');
    });

    var sql = "DROP TABLE IF EXISTS $STORENAME";
    db.transaction((SqlTransaction txn) {
      txn.executeSql(sql, [], (txn, resultSet) {
        log('drop table done');
      });
    }, (error) => c.completeError(error), (){
      var sql2 = "CREATE TABLE IF NOT EXISTS $STORENAME (id NVARCHAR(32) UNIQUE PRIMARY KEY, value TEXT)";
      db.transaction((SqlTransaction txn) {
        txn.executeSql(sql2, [], (txn, resultSet) {
          log('create table done');
          c.complete(db);
        });
      }, (error) => c.completeError(error));
    });


    return c.future;

  }
  void log(String txt){
    shadowRoot.appendHtml("<div>$txt</div>");
  }
}
//
//////next part uses a "little" help from lawdart library
//
class IndexDesc{
  String name;
  String keyPath;
  bool unique;
  bool multi;
  IndexDesc(this.name, this.keyPath, {this.unique:false, this.multi:false});
}
