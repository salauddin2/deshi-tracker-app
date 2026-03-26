import 'package:flutter/foundation.dart';

void main() {
  String a = '1';
  var map = <String, String>{
    'a': a
  };
  // Use map to stop the lint
  debugPrint(map.toString());
}
