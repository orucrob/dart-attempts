library testlist;

import 'package:polymer/polymer.dart';
import 'package:dart_attempts_lib/dartattemptslib.dart';
//import '../../lib/dartattemptslib.dart';

class ListItem extends Object with ChangeNotifier{
  @reflectable @observable bool get selected => __$selected; bool __$selected; @reflectable set selected(bool value) { __$selected = notifyPropertyChange(#selected, __$selected, value); }
  @reflectable @observable MyModel get item => __$item; MyModel __$item; @reflectable set item(MyModel value) { __$item = notifyPropertyChange(#item, __$item, value); }
  ListItem(item, [selected = false]) : __$item = item, __$selected = selected;

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
    super.ready();
    items.add(new ListItem(new MyModel()..foo="1"));
    items.add(new ListItem(new MyModel()..foo="2"));
    items.add(new ListItem(new MyModel()..foo="3"));
    items.add(new ListItem(new MyModel()..foo="4"));
  }

}
