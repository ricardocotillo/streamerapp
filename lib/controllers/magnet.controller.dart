import 'dart:typed_data';

import 'package:streamerapp/models/torrent.model.dart';
import 'package:streamerapp/services/magnet.service.dart';
import 'package:streamerapp/common/bencode.common.dart' as Bencode;

class MagnetController {
  MagnetService _magnetService = MagnetService();

  Future<Torrent> getTorrent(String url) async {
    final Uint8List t = await _magnetService.getTorrent(url);
    final dynamic decodedData = Bencode.decode(t);
    return Torrent.fromJson(decodedData);
  }
}
