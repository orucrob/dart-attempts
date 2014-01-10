library dartattemptslib;
import 'package:observe/observe.dart';

class MyModel extends Object with Observable{
  @observable String foo;
  String toString(){
    return "MyModel[foo:$foo]";
  }
}