library testlist;

import 'package:polymer/polymer.dart';
import 'dart:indexed_db' as idb;
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
  idb.Database _db;

  MyList.created() : super.created(){

    initDB().then((db){
      _db = db;
      //clear
      var trans = db.transaction(STORENAME, TXN_RW);
      var store = trans.objectStore(STORENAME);
      store.clear();
      return trans.completed;
    }).then((db){
      //insert
      var trans = db.transaction(STORENAME, TXN_RW);
      var store = trans.objectStore(STORENAME);
      store.put({INDEXNAME:"prvy"}, "1");
      store.put({INDEXNAME:"druhy"}, "2");
      store.put({INDEXNAME:"treti"}, "3");
      store.put({INDEXNAME:"stvrty"}, "4");
      return trans.completed;
    }).then((_){
      load();
    });


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
  void load(){
    items.clear();

    var trans = _db.transaction(STORENAME, TXN_RO);
    var store = trans.objectStore(STORENAME);
    var index = store.index(INDEXNAME);

    var range = new idb.KeyRange.bound("a","pr"+'\uffff');
    index.openCursor(range: range, autoAdvance: true).listen((cursor){
      var map = cursor.value;
      items.add(new ListItem(new MyModel()..foo=map[INDEXNAME]));
    });

//    store.allByIndex("name", only:"druhy").listen((map){
//      items.add(new ListItem(new MyModel()..foo=map["name"]));
//    });
  }
  Future<idb.Database> initDB(){
    return window.indexedDB.open(DBNAME).then((db){
      if (!db.objectStoreNames.contains(STORENAME)) {
        db.close();
        return window.indexedDB.open(DBNAME, version: db.version + 1,
            onUpgradeNeeded: (e) {
              idb.Database d = e.target.result;
              idb.ObjectStore os = d.createObjectStore(STORENAME);
              if(indexes!=null){
                indexes.forEach((index){
                  os.createIndex(index.name, index.keyPath, unique: index.unique, multiEntry: index.multi);
                });
              }
            }
        );
      } else {
        return db;
      }
    });
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

/**
 * Represents a Store that can hold key/value pairs. No order
 * is guaranteed for either keys or values. You must
 * [open] a store before you can use it.
 */
//abstract class Store<V> {
//  bool _isOpen = false;
//
//  bool get isOpen => _isOpen;
//
//  // For subclasses
//  Store._();
//
//  /**
//   * Finds the best implementation. In order: IndexedDB, WebSQL, LocalStorage.
//   */
//  factory Store(String dbName, String storeName, {Map options, List<IndexDesc> indexes}) {
//    return new IndexedDbStore(dbName, storeName, indexes: indexes);
////    if (IndexedDbStore.supported) {
////      return new IndexedDbStore(dbName, storeName, indexes: indexes);
////    } else if (WebSqlStore.supported) {
////      if (options != null && options['estimatedSize']) {
////        return new WebSqlStore(dbName, storeName, estimatedSize: options['estimatedSize']);
////      } else {
////        return new WebSqlStore(dbName, storeName);
////      }
////    } else {
////      return new LocalStorageStore();
////    }
//  }
//
//  _checkOpen() {
//    if (!isOpen) throw new StateError('$runtimeType is not open');
//  }
//
//  /// Returns a Future that completes when the store is opened.
//  /// You must call this method before using
//  /// the store.
//  Future open({force: false});
//
//  /// Returns all the keys as a stream. No order is guaranteed.
//  Stream<String> keys() {
//    _checkOpen();
//    return _keys();
//  }
//  Stream<String> _keys();
//
//  /// Stores an [obj] accessible by [key].
//  /// The returned Future completes with the key when the objects
//  /// is saved in the store.
//  Future<String> save(V obj, String key) {
//    _checkOpen();
//    if (key == null) {
//      throw new ArgumentError("key must not be null");
//    }
//    return _save(obj, key);
//  }
//  Future _save(V obj, String key);
//
//  /// Stores all objects by their keys. This should happen in a single
//  /// transaction if the underlying store supports it.
//  /// The returned Future completes when all objects have been added
//  /// to the store.
//  Future batch(Map<String, V> objectsByKey) {
//    _checkOpen();
//    return _batch(objectsByKey);
//  }
//  Future _batch(Map<String, V> objectsByKey);
//
//  /// Returns a Future that completes with the value for a key,
//  /// or null if the key does not exist.
//  Future<V> getByKey(String key) {
//    _checkOpen();
//    return _getByKey(key);
//  }
//  Future<V> _getByKey(String key);
//
//  /// Returns a Stream of all values for the keys.
//  /// If a particular key is not found,
//  /// no value will be returned, not even null.
//  Stream<V> getByKeys(Iterable<String> _keys) {
//    _checkOpen();
//    return _getByKeys(_keys);
//  }
//  Stream<V> _getByKeys(Iterable<String> _keys);
//
//  /// Returns a Future that completes with true if the key exists, or false.
//  Future<bool> exists(String key) {
//    _checkOpen();
//    return _exists(key);
//  }
//  Future<bool> _exists(String key);
//
//  /// Returns a Stream of all values in no particular order.
//  Stream<V> all() {
//    _checkOpen();
//    return _all();
//  }
//  Stream<V> _all();
//
//  /// Returns a Stream of all values in no particular order.
//  Stream<V> allByIndex(String idxName,{Object only, Object lower, Object upper, bool lowerOpen:false, bool upperOpen:false} ) {
//    _checkOpen();
//    return _allByIndex(idxName, only:only, lower:lower, upper:upper, lowerOpen:lowerOpen, upperOpen:upperOpen);
//  }
//  Stream<V> _allByIndex(String idxName,{Object only, Object lower, Object upper, bool lowerOpen:false, bool upperOpen:false});
//
//  /// Returns a Future that completes when the key's value is removed.
//  Future removeByKey(String key) {
//    _checkOpen();
//    return _removeByKey(key);
//  }
//  Future _removeByKey(key);
//
//  /// Returns a Future that completes when all the keys' values are removed.
//  Future removeByKeys(Iterable<String> _keys) {
//    _checkOpen();
//    return _removeByKeys(_keys);
//  }
//  Future _removeByKeys(Iterable<String> _keys);
//
//  /// Returns a Future that completes when all values and keys
//  /// are removed.
//  Future nuke() {
//    _checkOpen();
//    return _nuke();
//  }
//  Future _nuke();
//}
//
///**
// * Wraps the IndexedDB API and exposes it as a [Store].
// * IndexedDB is generally the preferred API if it is available.
// */
//class IndexedDbStore<V> extends Store<V> {
//
//  static Map<String, idb.Database> _databases = new Map<String, idb.Database>();
//
//  final String dbName;
//  final String storeName;
//  final List<IndexDesc> indexes;
//
//  IndexedDbStore(this.dbName, this.storeName,{this.indexes}) : super._();
//
//  /// Returns true if IndexedDB is supported on this platform.
//  static bool get supported => idb.IdbFactory.supported;
//
//  Future open({force: false}) {
//    if (!supported) {
//      return new Future.error(
//        new UnsupportedError('IndexedDB is not supported on this platform'));
//    }
//
//    if (_db != null && force) {
//      _db.close();
//      _databases[dbName]=null;
//
//    }
//    if(_db !=null){
//      return _initIdb(_db)
//        .then((db){
//          _databases[dbName] = db;
//          _isOpen = true;
//          return true;
//        });
//    }else{
//      return window.indexedDB.open(dbName).then((db){
//        return db;
//      }).then(_initIdb)
//        .then((db){
//          _databases[dbName] = db;
//          _isOpen = true;
//          return true;
//        });
//    }
//  }
//  Future _initIdb(idb.Database db){
//    if (!db.objectStoreNames.contains(storeName)) {
//      db.close();
//      print('Attempting upgrading $storeName from ${db.version}');
//      return window.indexedDB.open(dbName, version: db.version + 1,
//          onUpgradeNeeded: (e) {
//            print('Upgrading db $dbName to ${db.version + 1}');
//            idb.Database d = e.target.result;
//            idb.ObjectStore os = d.createObjectStore(storeName);
//            if(indexes!=null){
//              indexes.forEach((index){
//                os.createIndex(index.name, index.keyPath, unique: index.unique, multiEntry: index.multi);
//              });
//            }
//          }
//      );
//    } else {
//      print('The store $storeName exists in $dbName');
//      return new Future.value(db);
//    }
//  }
//
//  idb.Database get _db => _databases[dbName];
//
//  @override
//  Future _removeByKey(String  key) {
//    return _doCommand((idb.ObjectStore store) => store.delete(key));
//  }
//
//  @override
//  Future _save(V obj, String key) {
//    return _doCommand((idb.ObjectStore store) {
//      return store.put(obj, key);
//    });
//  }
//
//  @override
//  Future<V> _getByKey(String key) {
//    return _doCommand((idb.ObjectStore store) => store.getObject(key),
//        'readonly');
//  }
//
//  @override
//  Future _nuke() {
//    return _doCommand((idb.ObjectStore store) => store.clear());
//  }
//
//  Future _doCommand(Future requestCommand(idb.ObjectStore store),
//             [String txnMode = 'readwrite']) {
//    var completer = new Completer();
//    var trans = _db.transaction(storeName, txnMode);
//    var store = trans.objectStore(storeName);
//    var future = requestCommand(store);
//    return trans.completed.then((_) => future);
//  }
//
//  Stream _doGetAll(dynamic onCursor(idb.CursorWithValue cursor)) {
//    var controller = new StreamController<V>();
//    var trans = _db.transaction(storeName, 'readonly');
//    var store = trans.objectStore(storeName);
//    // Get everything in the store.
//    store.openCursor(autoAdvance: true).listen(
//        (cursor) => controller.add(onCursor(cursor)),
//        onDone: () => controller.close(),
//        onError: (e) => controller.addError(e));
//    return controller.stream;
//  }
//
//  Stream _doGetByIndex(String idxName, idb.KeyRange range, dynamic onCursor(idb.CursorWithValue cursor)) {
//    var controller = new StreamController<V>();
//    var trans = _db.transaction(storeName, 'readonly');
//    var store = trans.objectStore(storeName);
//    var index = store.index(idxName);
//    // Get everything in the store.
//    index.openCursor(range: range, autoAdvance: true).listen(
//        (cursor) => controller.add(onCursor(cursor)),
//        onDone: () => controller.close(),
//        onError: (e) => controller.addError(e));
//    return controller.stream;
//  }
//
//  @override
//  Stream<V> _all() {
//    return _doGetAll((idb.CursorWithValue cursor) => cursor.value);
//  }
//
//  @override
//  Stream<V> _allByIndex(String idxName,{Object only, Object lower, Object upper, bool lowerOpen:false, bool upperOpen:false} ) {
//    idb.KeyRange range = null;
//    if(only!=null){
//     range = new idb.KeyRange.only(only);
//    }else if(lower!=null && upper!=null){
//      range = new idb.KeyRange.bound(lower, upper, lowerOpen, upperOpen );
//    }else if(lower!=null ){
//      range = new idb.KeyRange.lowerBound(lower, lowerOpen);
//    }else if(upper!=null){
//      range = new idb.KeyRange.upperBound(upper, upperOpen );
//    }
//    return _doGetByIndex(idxName, range, (idb.CursorWithValue cursor) => cursor.value);
//  }
//
//  @override
//  Future _batch(Map<String, V> objs) {
//    var futures = <Future>[];
//
//    for (var key in objs.keys) {
//      var obj = objs[key];
//      futures.add(save(obj, key));
//    }
//
//    return Future.wait(futures);
//  }
//
//  @override
//  Stream<V> _getByKeys(Iterable<String> keys) {
//    var controller = new StreamController<V>();
//    Future.forEach(keys, (key) {
//      return getByKey(key).then((value) {
//        if (value != null) {
//          controller.add(value);
//        }
//      });
//    })
//    .then((_) => controller.close())
//    .catchError((e) => controller.addError(e));
//    return controller.stream;
//  }
//
//  @override
//  Future<bool> _removeByKeys(Iterable<String> keys) {
//    var completer = new Completer();
//    Future.wait(keys.map((key) => removeByKey(key))).then((_) {
//      completer.complete(true);
//    });
//    return completer.future;
//  }
//
//  @override
//  Future<bool> _exists(String key) {
//    return getByKey(key).then((value) => value != null);
//  }
//
//  @override
//  Stream<String> _keys() {
//    return _doGetAll((idb.CursorWithValue cursor) => cursor.key);
//  }
//}