library test;

import 'package:polymer/polymer.dart';
import 'package:dart_attempts_lib/dartattemptslib.dart'; //THIS IS PROBLEM
//import '../../lib/dartattemptslib.dart';  //THIS SOLVES PROBLEM


@CustomTag('my-input')
class MyInput extends PolymerElement {
  @published String value;
  valueChanged(oldValue){
    print('text changed from "$oldValue" to "$value"');
  }
  MyInput.created() : super.created();
}


@CustomTag('my-form')
class MyForm extends PolymerElement {
  @observable MyModel model = new MyModel();
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
