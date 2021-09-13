import 'dart:typed_data';

import 'package:streamerapp/services/base.service.dart';

class MagnetService {
  Future<Uint8List> getTorrent(String url) async {
    return BaseService.download(url);
  }
}
