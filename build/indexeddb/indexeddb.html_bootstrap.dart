library app_bootstrap;

import 'package:polymer/polymer.dart';

import 'all_elements.dart' as i0;
import 'indexeddb.html.0.dart' as i1;

void main() {
  configureForDeployment([
      'all_elements.dart',
      'indexeddb.html.0.dart',
    ]);
  i1.main();
}
