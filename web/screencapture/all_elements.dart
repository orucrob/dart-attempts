library testcapture;

import 'package:polymer/polymer.dart';
//import 'dart:indexed_db' as idb;
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

  MyList.created() : super.created(){


  }
  var idx = 0;
  var filters = ['grayscale', 'sepia', 'blur', 'brightness',
                 'contrast', 'hue-rotate', 'hue-rotate2',
                 'hue-rotate3', 'saturate', 'invert', ''];

  changeFilter(e, det, node) {
    HtmlElement el = e.target;
    el.className = '';
    var effect = filters[idx++ % filters.length]; // loop through filters.
    if (effect!=null) {
      el.classes..clear()..add(effect);
    }
    print("EL: $el  ${el.classes}");
  }
  var stream;
  void start(ev, detail, node){
    VideoElement video = $["vid"];
    if(stream==null){

      window.navigator.getUserMedia(video:{
        "mandatory": {
          "maxWidth": 1280,
          "maxHeight": 720
        }
      }
      ).then((s){
        stream = s;
        print('got stream');
        video..autoplay = true
        ..src = Url.createObjectUrlFromStream(stream);
      }, onError: (NavigatorUserMediaError err){
        print('heee": ${err} ${err.name}');
      });
    }else{
      video.pause();
      stream.stop();
      stream = null;


    }

  }
}
