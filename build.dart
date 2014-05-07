import 'package:polymer/builder.dart';

main(args) {
  build(entryPoints: ['web/external_model/external_model.html','web/list/list.html','web/indexeddb/indexeddb.html', 'web/screencapture/screencapture.html', 'web/websql/websql.html'],
        options: parseOptions(args));
}
