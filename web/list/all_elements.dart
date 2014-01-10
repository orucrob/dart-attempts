library testlist;

import 'package:polymer/polymer.dart';
import 'package:dart_attempts_lib/dartattemptslib.dart';
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



@CustomTag('my-list')
class MyList extends PolymerElement {
  //@observable MyModel model = new MyModel();
  List<ListItem> items = toObservable(new List());

  MyList.created() : super.created();
  void ready(){
    items.add(new ListItem(new MyModel()..foo="1"));
    items.add(new ListItem(new MyModel()..foo="2"));
    items.add(new ListItem(new MyModel()..foo="3"));
    items.add(new ListItem(new MyModel()..foo="4"));
  }

}
