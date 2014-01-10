import 'package:polymer/builder.dart';

main(args) {
  build(entryPoints: ['web/external_model/external_model.html','web/list/list.html'],
        options: parseOptions(args));
}
