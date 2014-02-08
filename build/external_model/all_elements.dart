library test;

import 'package:polymer/polymer.dart';
import 'package:dart_attempts_lib/dartattemptslib.dart'; //THIS IS PROBLEM
//import '../../lib/dartattemptslib.dart';  //THIS SOLVES PROBLEM


@CustomTag('my-input')
class MyInput extends PolymerElement with ChangeNotifier  {
  @reflectable @published String get value => __$value; String __$value; @reflectable set value(String value) { __$value = notifyPropertyChange(#value, __$value, value); }
  valueChanged(oldValue){
    print('text changed from "$oldValue" to "$value"');
  }
  MyInput.created() : super.created();
}


@CustomTag('my-form')
class MyForm extends PolymerElement with ChangeNotifier  {
  @reflectable @observable MyModel get model => __$model; MyModel __$model = new MyModel(); @reflectable set model(MyModel value) { __$model = notifyPropertyChange(#model, __$model, value); }
  modelChanged(oldValue){
    print('text changed from "$oldValue" to "$model"');
  }

  MyForm.created() : super.created();
  void ready(){
    model.changes.listen((changes){
      print('model properties changed $changes');
    });
  }

}
