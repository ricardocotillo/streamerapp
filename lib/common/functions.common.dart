// static const START_CONNECTION_ID = [0, 0, 4, 23, 39, 16, 25, 128];
// static const ACTION_CONNECT = [0, 0, 0, 0];

import 'dart:convert';
import 'dart:math';

import 'dart:typed_data';

List<int> randomBytes(count, [bool typedList = false]) {
  var random = Random();
  var bytes;
  if (typedList) {
    bytes = Uint8List(count);
    for (var i = 0; i < count; i++) {
      bytes[i] = random.nextInt(256);
    }
  } else {
    bytes = <int>[];
    for (var i = 0; i < count; i++) {
      bytes.add(random.nextInt(256));
    }
  }
  return bytes;
}

Uint8List genId() {
  final Uint8List id = Uint8List.fromList(randomBytes(20));
  id.setAll(0, utf8.encode('-AT0001-'));
  return id;
}
